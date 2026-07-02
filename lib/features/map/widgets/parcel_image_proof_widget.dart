import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_proof_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelImageProofWidget extends StatelessWidget {
  final bool froPickupImage;
  const ParcelImageProofWidget({super.key, required this.froPickupImage});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpTimeCountController>(builder: (otpTimerController){
      return Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            color: Theme.of(context).hintColor.withValues(alpha: 0.1)
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(froPickupImage ? 'uploaded_picked_image'.tr : 'upload_delivery_image'.tr, style: textSemiBold),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(height: 70,
            child: ListView.separated(
              itemCount: froPickupImage ?
              otpTimerController.parcelReceivingImage.length >= 5 ? 5 : otpTimerController.parcelReceivingImage.length+ 1 :
              otpTimerController.parcelDeliveryImage.length >= 5 ? 5 : otpTimerController.parcelDeliveryImage.length+ 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index){
                return index ==  (froPickupImage ? otpTimerController.parcelReceivingImage.length : otpTimerController.parcelDeliveryImage.length) ?
                InkWell(
                  onTap: (){
                    Get.bottomSheet(
                        backgroundColor: Theme.of(context).cardColor,
                        ParcelProofBottomSheetWidget(froPickupImage: froPickupImage)
                    );
                  },
                  child: Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.2)
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: EdgeInsets.only(top: 8, right: 8),
                    child: Image.asset(Images.cameraPlaceholder, color: Theme.of(context).primaryColor),
                  ),
                ) :
                Stack(children: [
                  Container(width: 60, height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    ),
                    margin: EdgeInsets.only(right: 8, top: 8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                      child: Image.file(
                        File(
                            froPickupImage ?
                            otpTimerController.parcelReceivingImage[index].path :
                            otpTimerController.parcelDeliveryImage[index].path
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0, top: 0,
                    child: InkWell(
                      onTap: (){
                        otpTimerController.removeImage(index, froPickupImage);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.error
                        ),
                        padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Image.asset(Images.crossIcon, color: Theme.of(context).cardColor, height: Dimensions.paddingSizeSmall, width: Dimensions.paddingSizeSmall),
                      ),
                    ),
                  )
                ]);
              },
              separatorBuilder: (idx, ctx){
                return SizedBox(width: Dimensions.paddingSizeSmall);
              },
            ),
          )
        ]),
      );
    });
  }
}
