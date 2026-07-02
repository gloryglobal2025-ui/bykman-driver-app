import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class BiometricAuthBottomSheetWidget extends StatefulWidget {
  const BiometricAuthBottomSheetWidget({super.key});

  @override
  State<BiometricAuthBottomSheetWidget> createState() => _BiometricAuthBottomSheetWidgetState();
}

class _BiometricAuthBottomSheetWidgetState extends State<BiometricAuthBottomSheetWidget> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      bool isBiometricListEmpty = authController.bioList.isEmpty;

      return Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 5, width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: ()=> Get.back(),
                      child: Icon(Icons.close, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                    ),
                  ),

                  Container(
                    height: 80, width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isBiometricListEmpty ?
                      Theme.of(context).primaryColor.withValues(alpha: 0.5) :
                      Theme.of(context).hintColor.withValues(alpha: 0.1)),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Image.asset(isBiometricListEmpty ? Images.biometricIcon : Images.biometricPassword),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  if(isBiometricListEmpty)...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        'please_set_up_face_id_or_fingerprint_on_your_device'.tr,
                        style: textSemiBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    ButtonWidget(
                      buttonText: 'go_to_setting'.tr,
                      onPressed: () {
                        authController.goToSettings();
                      },
                      radius: 50, width: Get.width * 0.5,
                    ),
                  ]
                  else...[
                    Text(
                      authController.isBiometricEnable ?
                      'enter_your_password_to_off_biometric_login'.tr :
                      'enter_your_password_to_on_biometric_login'.tr,
                      style: textSemiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: TextFieldWidget(
                        hintText: 'enter_your_password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Images.lock,
                        isPassword: true,
                        showBorder: true,
                        borderRadius: 50,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    ButtonWidget(
                      buttonText: 'submit'.tr,
                      onPressed: () {
                        if (_passwordController.text.isNotEmpty) {
                          if(authController.isBiometricEnable){
                            authController.setBiometricEnable(false, _passwordController.text.trim());
                          }else{
                            authController.setBiometricEnable(true, _passwordController.text.trim());
                          }
                        }
                      },
                      radius: 50, width: 160,
                    ),
                  ],
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
              ),
            ),
          ),
        ),
      ]);
    });
  }
}
