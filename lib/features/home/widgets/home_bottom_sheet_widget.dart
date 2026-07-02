import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/features/home/screens/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HomeVehicleAddBottomSheet extends StatelessWidget {
  const HomeVehicleAddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft:  Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeDefault,
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).highlightColor
                  ), height: Dimensions.paddingSizeExtraSmall, width: 40
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Image.asset(Images.carFrontIcon, height: 60, width: 60),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('vehicle_information'.tr, style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeLarge
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'add_your_vehicle_info_now'.tr,
                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSignUp),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2).copyWith(bottom: Dimensions.paddingSizeSmall),
                child: ButtonWidget(
                  buttonText: 'add_vehicle_info'.tr,
                  onPressed: ()=> Get.to(()=> const VehicleAddScreen()),
                ),
              )

            ]),
          ),
        ),
      ),
    );
  }
}


class HomeFaceVerificationBottomSheet extends StatelessWidget {
  const HomeFaceVerificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft:  Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeDefault,
          ),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).highlightColor
                    ), height: Dimensions.paddingSizeExtraSmall, width: 40
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Image.asset(Images.faceDetectionIcon, height: 60, width: 60),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('verify_your_identity'.tr, style: textSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'please_complete_face_verification_to_become'.tr,
                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSignUp),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                child: ButtonWidget(
                  buttonText: 'verify_your_identity'.tr,
                  onPressed: (){
                    Get.back(result: false);
                    Get.find<FaceVerificationController>().requestCameraPermission();
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InkWell(
                onTap: ()=> Get.back(result: true),
                child: Text('i_will_do_it_later'.tr, style: textBold.copyWith(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.surfaceContainer
                )),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge)

            ]),
          ),
        ),
      ),
    );
  }
}

