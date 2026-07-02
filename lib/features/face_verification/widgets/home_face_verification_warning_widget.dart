import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/extension_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HomeFaceVerificationWarningWidget extends StatelessWidget {
  const HomeFaceVerificationWarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height * 0.1, right: 0, left: 0,
      child: Container(
        decoration: BoxDecoration(
            color: context.customThemeColors.warningBackGroundColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9), size: 18),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('your_account_has_been_suspended'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9))),

              const Spacer(),

              InkWell(
                onTap: ()=> Get.find<ProfileController>().removeFaveVerificationSuspendWarning(),
                child: Container(
                  height: 16, width: 16,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.asset(Images.crossIcon, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                ),
              )
            ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if(Get.find<ProfileController>().profileInfo?.suspendReason == 'face_verification')
          RichText(text: TextSpan(
              text: '${'your_account_is_suspend_for_face_verification'.tr} ',
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = (){
                      Get.find<FaceVerificationController>().requestCameraPermission();
                    },
                    text: 'verify_now'.tr, style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  decoration: TextDecoration.underline,
                )),
              ],
            ))

        ]),
      ),
    );
  }
}
