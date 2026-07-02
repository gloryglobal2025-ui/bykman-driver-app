import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/screens/biometric_login_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_up_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/features/html/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/html/screens/policy_viewer_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class OtpLoginScreen extends StatefulWidget {
  final bool fromSignIn;
  const OtpLoginScreen({super.key, this.fromSignIn = false});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().config!.countryCode!).dialCode!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: GetBuilder<AuthController>(builder: (authController){
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset(Images.logoWithName, height: 75, width: 200)),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    FutureBuilder<String>(
                        future: loadSvgAndChangeColors(Images.otpLoginGraphics, Theme.of(context).primaryColor),
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return SvgPicture.string(
                                snapshot.data!
                            );
                          }
                          return SvgPicture.asset(Images.otpLoginGraphics);
                        }
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'login_with_otp'.tr,
                      style: textBold.copyWith(fontSize: Dimensions.fontSizeTwenty),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      'please_enter_your_mobile_number_to_continue'.tr,
                      style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    TextFieldWidget(
                      hintText: 'phone'.tr,
                      inputType: TextInputType.number,
                      countryDialCode: authController.countryDialCode,
                      controller: phoneController,
                      focusNode: phoneNode,
                      inputAction: TextInputAction.done,
                      onCountryChanged: (CountryCode countryCode){
                        authController.countryDialCode = countryCode.dialCode!;
                        authController.setCountryCode(countryCode.dialCode!);
                      },
                      autoFocus: phoneController.text.isEmpty,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    authController.isOtpSending ?
                    Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                    ButtonWidget(
                      buttonText: 'get_otp'.tr,
                      onPressed: () {
                        String phone = phoneController.text.trim();

                        if(phone.isEmpty) {
                          showCustomSnackBar('enter_your_phone_number'.tr);
                          FocusScope.of(context).requestFocus(phoneNode);
                        }else if(!GetUtils.isPhoneNumber(authController.countryDialCode + phone)) {
                          showCustomSnackBar('phone_number_is_not_valid'.tr);
                        }else {
                          authController.checkOAuth(countryCode: authController.countryDialCode, number: phone).then((value){
                            if(value.statusCode == 200){
                              if(Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false){
                                authController.firebaseOtpSend(countryCode: authController.countryDialCode , number: phone, from: VerificationForm.login);
                              }else if(Get.find<SplashController>().config?.isSmsGateway ?? false){
                                authController.sendOtp(countryCode:  authController.countryDialCode, number:  phone).then((value) {
                                  if(value.statusCode == 200) {
                                    Get.to(() =>  VerificationScreen(
                                      countryCode: authController.countryDialCode , number: phone,
                                      form: widget.fromSignIn ? VerificationForm.login : VerificationForm.signUp,
                                    ));
                                  }
                                });
                              }else{
                                showCustomSnackBar('sms_gateway_not_integrate'.tr);
                              }
                            }
                          });

                        }
                      },
                      radius: 50,
                    ),

                    if(authController.isBiometricEnable && (Get.find<SplashController>().config?.driverLoginOptions?.biometricLogin ?? false))...[
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      ButtonWidget(
                        showBorder: true,
                        borderWidth: 1,
                        transparent: true,
                        buttonText: 'biometric_login'.tr,
                        onPressed: () => Get.to(() => const BiometricLoginScreen()),
                        radius: 50,
                      ),
                    ],

                    if(Get.find<SplashController>().config?.driverLoginOptions?.manualLogin ?? false)...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: 8),
                          child: Text('or'.tr ,style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                        ),
                      ),

                      ButtonWidget(
                        showBorder: true,
                        borderWidth: 1,
                        transparent: true,
                        buttonText: 'login'.tr,
                        onPressed: () => Get.back(),
                        radius: 50,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      (Get.find<SplashController>().config!.selfRegistration != null &&
                          Get.find<SplashController>().config!.selfRegistration!) ?
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          '${'do_not_have_an_account'.tr} ',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ),
                        ),

                        TextButton(
                          onPressed: () =>  Get.to(()=> const SignUpScreen()),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, minimumSize: const Size(50,30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'sign_up'.tr,
                            style: textMedium.copyWith(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                              decorationColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ]) :
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text("${'to_create_account'.tr} "),

                        InkWell(
                          onTap: ()=>
                              Get.find<SplashController>().sendMailOrCall(
                                "tel:${Get.find<SplashController>().config?.businessContactPhone}",
                                false,
                              ),
                          child: Text(
                            "${'contact_support'.tr} ",
                            style: textRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ]),
                    ],

                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Align(alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: ()=> Get.to(() =>  const PolicyViewerScreen(htmlType: HtmlType.termsAndConditions)),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Text("terms_and_condition".tr, style: textMedium.copyWith(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeSmall,
                            decorationColor: Theme.of(context).primaryColor
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
