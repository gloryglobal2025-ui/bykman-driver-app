import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/additional_sign_up_screen_1.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/signup_appbar_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  void initState() {
    Get.find<AuthController>().loadAdditionalFields(false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          body: GetBuilder<AuthController>(builder:(authController){
            return Column(children: [
              SignUpAppbarWidget(
                  enableBackButton: true, title: 'signup_as_a_driver',
                  progressText: (Get.find<SplashController>().config?.additionalFieldList ?? []).isNotEmpty ? '1_of_4' : '1_of_3'
              ),
              const SizedBox(height: Dimensions.paddingSizeSignUp),

              Expanded(
                child: SingleChildScrollView(child: Column(children: [
                  SvgPicture.asset(Images.logoWithNameSvg, height: 40),
                  const SizedBox(height: Dimensions.paddingSizeSignUp),

                  FutureBuilder<String>(
                      future: loadSvgAndChangeColors(Images.signUpScreenLogoSvg, Theme.of(context).primaryColor),
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return SvgPicture.string(
                              snapshot.data!
                          );
                        }
                        return SvgPicture.asset(Images.signUpScreenLogoSvg);
                      }
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSignUp),

                  Text('choose_service'.tr,style: textBold.copyWith(fontSize: 22)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text('select_your_preferable_service'.tr,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSignUp),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: authController.isRideShare ?
                      Theme.of(context).primaryColor.withValues(alpha: 0.5) :
                      Theme.of(context).hintColor.withValues(alpha: 0.5),
                        width: 0.5
                      ),

                    ),
                    child: Center(
                      child: CheckboxListTile(
                        contentPadding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        title: Text('ride_share'.tr,style: textBold.copyWith(
                            fontSize: 14,
                            color: authController.isRideShare ?
                            Theme.of(context).textTheme.bodyMedium?.color :
                            Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
                        )),
                        value: authController.isRideShare,
                        onChanged: (value){
                          authController.updateServiceType(true);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        subtitle: Text('service_provide_text1'.tr,style: textRegular.copyWith(
                          color: authController.isRideShare ?
                          Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) :
                          Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                          fontSize: 10,
                        )),
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: authController.isParcelShare ?
                      Theme.of(context).primaryColor.withValues(alpha: 0.5) :
                      Theme.of(context).hintColor.withValues(alpha: 0.5),
                        width: 0.5
                      ),
                    ),
                    child: Center(
                      child: CheckboxListTile(
                        contentPadding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        title: Text('parcel_delivery'.tr,style: textBold.copyWith(
                            fontSize: 14,
                            color: authController.isParcelShare ?
                            Theme.of(context).textTheme.bodyMedium?.color :
                            Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
                        )),
                        value: authController.isParcelShare,
                        onChanged: (value){
                          authController.updateServiceType(false);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        checkColor: Colors.white,
                        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        subtitle: Text('service_provide_text2'.tr, style: textRegular.copyWith(
                            color: authController.isParcelShare ?
                            Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) :
                            Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                            fontSize: 10
                        )),
                      ),
                    ),
                  ),
                ])),
              ),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.15), blurRadius: 10, offset: Offset(0, -4))],
                  borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeLarge), topLeft: Radius.circular(Dimensions.paddingSizeLarge)),
                  color: Theme.of(context).cardColor
                ),
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall).copyWith(bottom: Dimensions.paddingSizeExtraLarge),
                child: ButtonWidget(
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  radius: Dimensions.radiusExtraLarge,
                  buttonText: 'next'.tr,
                  onPressed: (){
                    if(!authController.isRideShare && !authController.isParcelShare){
                      showCustomSnackBar('required_to_select_service'.tr);
                    }else{
                      Get.to(()=> const AdditionalSignUpScreen1());
                    }

                  },
                ),
              ),
            ]);
          })
      ),
    );
  }
}
