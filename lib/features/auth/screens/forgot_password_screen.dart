import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_up_screen.dart';
import 'package:ride_sharing_user_app/features/help_and_support/screens/help_and_support_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? phoneNumber;
  final VerificationForm from;
  const ForgotPasswordScreen({super.key, this.phoneNumber, required this.from});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isOtpOptionEnable =  true;
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    isOtpOptionEnable = ((Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false) || (Get.find<SplashController>().config?.isSmsGateway ?? false));
    if(widget.phoneNumber != null){
      phoneController.text = widget.phoneNumber!;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBarWidget(
          title: widget.from == VerificationForm.resetPassword ? 'forget_password'.tr : 'verify_customer'.tr,
          showBackButton: true, regularAppbar: true,
        ),
        body: GetBuilder<AuthController>(builder: (authController){

          if (isOtpOptionEnable) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.orderStatusIconHeight),

                        FutureBuilder<String>(
                            future: loadSvgAndChangeColors(Images.forgetPasswordGraphics, Theme.of(context).primaryColor),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                return SvgPicture.string(snapshot.data!);
                              }
                              return SvgPicture.asset(Images.forgetPasswordGraphics);
                            }
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          widget.from == VerificationForm.resetPassword ?
                          'forget_your_password'.tr :
                          'verify_yourself'.tr,
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeTwenty),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text(
                          'enter_your_phone_to_receive_a_reset_code'.tr,
                          style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeSmall),
                          maxLines: 2,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSignUp),

                        TextFieldWidget(
                          hintText: 'enter_your_phone'.tr,
                          inputType: TextInputType.number,
                          countryDialCode: authController.countryDialCode,
                          controller: phoneController,
                          onCountryChanged: (CountryCode countryCode) {
                            authController.countryDialCode =
                            countryCode.dialCode!;
                            authController.setCountryCode(countryCode.dialCode!);
                          },
                          autoFocus: phoneController.text.isEmpty,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        authController.isOtpSending ?
                        Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                        ButtonWidget(
                          buttonText: 'get_otp'.tr, radius: 50,
                          onPressed: () {
                            String phoneNumber = phoneController.text;
                            if (phoneNumber.isEmpty) {
                              showCustomSnackBar('phone_is_required'.tr);
                            } else {
                              if (Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false) {
                                authController.firebaseOtpSend(
                                    countryCode: authController.countryDialCode,
                                    number: phoneNumber,
                                    from: widget.from
                                );
                              } else if (Get.find<SplashController>().config?.isSmsGateway ?? false) {
                                authController.sendOtp(
                                    countryCode: authController.countryDialCode,
                                    number: phoneNumber).then((value) {
                                  if (value.statusCode == 200) {
                                    Get.to(() => VerificationScreen(
                                      countryCode: authController.countryDialCode,
                                      number: phoneNumber,
                                      form: widget.from,
                                    ));
                                  }
                                });
                              } else {
                                showCustomSnackBar('sms_gateway_not_integrate'.tr);
                              }
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        if(widget.from == VerificationForm.resetPassword)...[
                          (Get.find<SplashController>().config!.selfRegistration != null && Get.find<SplashController>().config!.selfRegistration!) ?
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(
                              '${'do_not_have_an_account'.tr} ',
                              style: textMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),

                            TextButton(
                              onPressed: () => Get.to(() => const SignUpScreen()),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),

                              child: Text(
                                'join_as_driver'.tr,
                                style: textMedium.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor,
                                  decorationColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ]) :
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${'to_create_account'.tr} "),

                              InkWell(
                                onTap: () => Get.find<SplashController>().sendMailOrCall("tel:${Get.find<SplashController>().config?.businessContactPhone}", false),
                                child: Text(
                                  "${'contact_support'.tr} ",
                                  style: textRegular.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]

                      ]),
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Image.asset(Images.warning, height: 40, width: 40),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: 'password_recovery_is_temporary_unavailable'.tr,
                                  style: textSemiBold.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),

                                const TextSpan(text: '\n'),

                                TextSpan(
                                  text: 'please_contact_our'.tr,
                                  style: textMedium.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),

                                TextSpan(
                                  text: 'support'.tr,
                                  style: textMedium.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.to(() => const HelpAndSupportScreen()),
                                ),

                                TextSpan(
                                  text: ' ${'team_for_assistance'.tr}',
                                  style: textMedium.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      ButtonWidget(
                        showBorder: true,
                        borderWidth: 1,
                        buttonText: 'contact_support'.tr,
                        onPressed: () => Get.to(() => const HelpAndSupportScreen()),
                        radius: 50,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],
                  ),
                ),
              );
            },
          );

        }),
      ),
    );
  }
}
