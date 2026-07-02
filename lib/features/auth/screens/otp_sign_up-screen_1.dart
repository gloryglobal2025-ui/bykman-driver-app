import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/otp_sign_up-screen_2.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/text_field_title_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OtpSignUpScreen1 extends StatefulWidget {
  final String phoneNumber;
  const OtpSignUpScreen1({super.key, required this.phoneNumber});

  @override
  State<OtpSignUpScreen1> createState() => _OtpSignUpScreen1State();
}

class _OtpSignUpScreen1State extends State<OtpSignUpScreen1> {

  @override
  void initState() {
    Get.find<AuthController>().loadAdditionalFields(true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          return Column(children: [
            _buildAppBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: Dimensions.paddingSizeSignUp),

                  Center(
                    child: Text(
                      'create_account'.tr,
                      style: textBold.copyWith(
                          fontSize : Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).textTheme.bodyMedium?.color
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Center(child: Text(
                    'complete_your_profile_to_create_account'.tr,
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('choose_service'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    'select_your_preferable_service'.tr,
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(
                        color: authController.isRideShare
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                            : Theme.of(context).hintColor.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      title: Text(
                        'ride_share'.tr,
                        style: textBold.copyWith(
                          fontSize: Dimensions.paddingSizeDefault,
                          color: authController.isRideShare ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                      value: authController.isRideShare,
                      onChanged: (_) => authController.updateServiceType(true),
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                      subtitle: Text(
                        'service_provide_text1'.tr,
                        style: textRegular.copyWith(
                          color: authController.isRideShare ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(
                        color: authController.isParcelShare ? Theme.of(context).primaryColor.withValues(alpha: 0.5) : Theme.of(context).hintColor.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      title: Text(
                        'parcel_delivery'.tr,
                        style: textBold.copyWith(
                          fontSize: Dimensions.paddingSizeDefault,
                          color: authController.isParcelShare ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                      value: authController.isParcelShare,
                      onChanged: (_) => authController.updateServiceType(false),
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                      subtitle: Text(
                        'service_provide_text2'.tr,
                        style: textRegular.copyWith(
                          color: authController.isParcelShare ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('provide_basic_info'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    'enter_your_information'.tr,
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),

                  TextFieldTitleWidget(title: 'first_name'.tr, isRequired: true),

                  TextFieldWidget(
                    hintText: 'enter_your_first_name'.tr,
                    capitalization: TextCapitalization.words,
                    inputType: TextInputType.name,
                    prefixIcon: Images.person,
                    controller: authController.fNameController,
                    focusNode: authController.fNameNode,
                    nextFocus: authController.lNameNode,
                    inputAction: TextInputAction.next,
                    autoFocus: authController.fNameController.text.isEmpty,
                  ),

                  TextFieldTitleWidget(title: 'last_name'.tr),

                  TextFieldWidget(
                    hintText: 'enter_your_last_name'.tr,
                    capitalization: TextCapitalization.words,
                    inputType: TextInputType.name,
                    prefixIcon: Images.person,
                    controller: authController.lNameController,
                    focusNode: authController.lNameNode,
                    nextFocus: authController.referralNode,
                    inputAction: TextInputAction.next,
                  ),

                  if (Get.find<SplashController>().config?.referralEarningStatus ?? false) ...[
                    TextFieldTitleWidget(title: 'referral_code'.tr),
                    TextFieldWidget(
                      hintText: 'enter_refer_code'.tr,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      prefixIcon: Images.referIcon,
                      controller: authController.referralCodeController,
                      focusNode: authController.referralNode,
                      inputAction: TextInputAction.done,
                    ),
                  ],

                  TextFieldTitleWidget(title: 'gender'.tr, isRequired: true),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: .7,color: Theme.of(context).hintColor.withValues(alpha: .3)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                    ),
                    child: Row(children: [
                      Image.asset(Images.identityIcon, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Expanded(
                        child: DropdownButton<String>(
                          value: authController.selectedGender,
                          items: authController.genderList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr,style: textRegular.copyWith(
                                color: value == 'select_gender' ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) : Theme.of(context).textTheme.bodyMedium!.color,
                              )),
                            );
                          }).toList(),
                          onChanged: (value) {
                            authController.setGender(value);
                          },
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          underline: const SizedBox(),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.paddingSizeLarge),
                  topLeft: Radius.circular(Dimensions.paddingSizeLarge),
                ),
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeExtraSmall,
              ).copyWith(bottom: Dimensions.paddingSizeExtraLarge),
              child: ButtonWidget(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                radius: Dimensions.radiusExtraLarge,
                buttonText: 'next'.tr,
                onPressed: () {
                  if (!authController.isRideShare && !authController.isParcelShare) {
                    showCustomSnackBar('required_to_select_service'.tr);
                  } else if (authController.fNameController.text.trim().isEmpty) {
                    showCustomSnackBar('first_name_is_required'.tr);
                    FocusScope.of(context).requestFocus(authController.fNameNode);
                  }else if(authController.selectedGender.isEmpty || authController.selectedGender == 'select_gender'){
                    showCustomSnackBar('required_the_gender'.tr);
                  } else {
                    Get.to(() => OtpSignUpScreen2(phoneNumber: widget.phoneNumber));
                  }
                },
              ),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            color: Theme.of(context).textTheme.bodyMedium?.color,
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'setup_profile'.tr,
            style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        Row(
          children: [
            Container(
                height: 3,
                width: Get.width*0.5,
                color: Theme.of(context).primaryColor
            ),
            Container(
                height: 3,
                width: Get.width*0.5,
                color: Theme.of(context).hintColor.withValues(alpha: 0.2)
            ),
          ],
        ),
      ]
      ),
    );
  }
}
