import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/home/screens/vehicle_add_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class VehiclePendingWidget extends StatelessWidget {
  const VehiclePendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(width: .5,color: Theme.of(context).highlightColor.withValues(alpha: 0.5))
      ),
      child: GetBuilder<ProfileController>(builder: (profileController){
        return Column(children: [
          if(Get.find<ProfileController>().profileInfo?.vehicle?.vehicleRequestStatus == 'pending')...[
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Text(
                'vehicle_registration_is_under_review'.tr,
                style: textMedium,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'please_wait_until_admin_approve_your_request'.tr,
                style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Image.asset(Images.waitingCarIcon, height: 60, width: 60),
          ] else...[
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Text(
                'vehicle_registration_deny'.tr,
                style: textMedium,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: RichText(text: TextSpan(
                text: 'deny_note'.tr,
                style: textRegular.copyWith(color: Theme.of(context).colorScheme.error),
                children: [
                  TextSpan(
                      text: ' ${profileController.profileInfo?.vehicle?.denyNote}',
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)
                  )
                ]
              )),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Image.asset(Images.deniedCarIcon, height: 60, width: 60),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOver,vertical: Dimensions.paddingSizeDefault),
              child: ButtonWidget(
                buttonText: 'update_vehicle_info'.tr,
                onPressed: ()=> Get.to(()=> VehicleAddScreen(vehicleInfo: Get.find<ProfileController>().profileInfo?.vehicle)),
              ),
            )
          ],

        ]);
      }),
    );
  }
}
