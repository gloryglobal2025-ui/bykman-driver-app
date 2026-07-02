import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/features/face_verification/screens/face_verification_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class FaceVerificationResultScreen extends StatelessWidget {
  final bool isSuccess;
  final String message;
  const FaceVerificationResultScreen({super.key, required this.isSuccess, required this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (res,data){
          if(!isSuccess){
            Get.find<FaceVerificationController>().skipFaceVerification(fromVarificationScreen: true);
          }
          if(!res){
            Get.offAll(()=> const DashboardScreen());
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBarWidget(title: 'verify_your_identity'.tr, regularAppbar: true),
          body: GetBuilder<FaceVerificationController>(builder: (faceVerificationController){
            return SingleChildScrollView(
              child: Column(children: [
                Divider(color: Theme.of(context).highlightColor.withValues(alpha: 0.2), thickness: 2),
              
                if(isSuccess)...[
                  const SizedBox(height: Dimensions.paddingSizeSignUp),
              
                  Center(
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        radius: 70, backgroundImage: FileImage(faceVerificationController.getImage!),
                      ),
              
                      Positioned(right: 0,top: 0,
                        child: Container(height: 35, width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor
                          ),
              
                          child: Center(
                            child: Container(height: 25, width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green
                              ),
                              padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Center(child: Image.asset(Images.rightSignIcon)),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              
                  Text('identity_verified'.tr, style: textBold),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              
                  Text('now_you_are_a_verified_driver'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
                  const SizedBox(height: Dimensions.paddingSizeOver),
              
                  ButtonWidget(
                    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                    buttonText: 'continue_driving'.tr,
                    onPressed: ()=> Get.offAll(()=> const DashboardScreen()),
                  )
                ]
                else...[
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: Dimensions.paddingSizeDefault),
                    child: Image.asset(Images.verificationPlaceHolder),
                  ),
              
                  Text('identity_verify_failed'.tr, style: textBold.copyWith(color: Theme.of(context).colorScheme.error)),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
              
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Text('make_sure_your_face_is_clearly_visible'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
              
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: RichText(text: TextSpan(
                        text: 'failed_reason'.tr,
                        style: textRegular.copyWith(color: Theme.of(context).colorScheme.error),
                        children: [
                          TextSpan(
                              text: ' $message',
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)
                          )
                        ]
                    )),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSignUp),
              
                  ButtonWidget(
                    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
                    buttonText: 'try_again'.tr,
                    onPressed: ()=> Get.offAll(()=> const FaceVerificationScreen()),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
              
                  InkWell(
                    onTap: (){
                      Get.offAll(()=> const DashboardScreen());
                      faceVerificationController.skipFaceVerification(fromVarificationScreen: true);
                    },
                    child: Text(
                      'try_later'.tr,
                      style: textRegular.copyWith(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        decoration: TextDecoration.underline, decorationColor: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSignUp)
              
                ]
              ]),
            );
          }),
        )
    );
  }
}
