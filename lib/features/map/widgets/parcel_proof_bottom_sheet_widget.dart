import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class ParcelProofBottomSheetWidget extends StatelessWidget {
  final bool froPickupImage;
  const ParcelProofBottomSheetWidget({super.key, required this.froPickupImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: Dimensions.paddingSizeExtraSmall, width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(50)
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
          child: Text('Please upload a photo to give proof as you taken the parcel delivery', textAlign: TextAlign.center),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          SizedBox(
            width: Get.width * 0.45,
            child: InkWell(
              onTap: ()=> Get.find<OtpTimeCountController>().pickProofImage(ImageSource.camera, froPickupImage),
              child: Column(children: [
                Container(
                  height: 60, width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Image.asset(Images.cameraPlaceholder, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text('camera'.tr)
              ]),
            ),
          ),

          SizedBox(
            width: Get.width * 0.45,
            child: InkWell(
              onTap: ()=> Get.find<OtpTimeCountController>().pickProofImage(ImageSource.gallery, froPickupImage),
              child: Column(children: [
                Container(
                  height: 60, width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Image.asset(Images.galleryIcon, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text('from_gallery'.tr)
              ]),
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

      ]),
    );
  }
}
