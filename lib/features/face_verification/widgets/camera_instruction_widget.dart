import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CameraInstructionWidget extends StatelessWidget {
  const CameraInstructionWidget({super.key });


  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaceVerificationController>(
        builder: (faceVerificationController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text('blinking_you_eye'.tr,
                  style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 2, textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text('please_keep_your_face_centered'.tr,
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6)), maxLines: 2, textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeOver),

            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                padding: EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: Dimensions.paddingSizeSmall),
                child: Column(children: [
                  Text('scanning_your_face'.tr, style: textMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  LinearProgressIndicator(
                    value: faceVerificationController.eyeBlink / 3,
                    minHeight: Dimensions.paddingSizeSmall,
                    borderRadius: BorderRadius.circular(50),
                    backgroundColor: Theme.of(context).highlightColor.withValues(alpha: 0.3),
                    color: Theme.of(context).primaryColor,
                  )
                ]),
              ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if(!faceVerificationController.isSuccess)
              ButtonWidget(
                  onPressed: (){
                    faceVerificationController.valueInitialize();
                    faceVerificationController.startLiveFeed();
                  },
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  buttonText: 'try_again'.tr
              ),

            const Spacer(),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text('make_sure_your_face_is_clearly_visible'.tr,
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6)), maxLines: 2, textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ]);
        }
    );
  }
}