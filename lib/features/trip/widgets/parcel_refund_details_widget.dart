import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/enums/refund_status_enum.dart';
import 'package:ride_sharing_user_app/features/trip/screens/image_video_viewer.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/customer_note_view_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/payable_history_screen.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelRefundDetailsWidget extends StatelessWidget {
  const ParcelRefundDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if(rideController.tripDetail?.parcelRefund?.status == RefundStatus.refunded)...[
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.05)
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('refunded_by_admin'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(PriceConverter.convertPrice(context, rideController.tripDetail?.parcelRefund?.refundAmountByAdmin ?? 0),style: textRobotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                RichText(text: TextSpan(
                  text: '${'this_amount_is_deduct_from'.tr} ',
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=> const PayableHistoryScreen()),
                        text: 'payable_balance'.tr, style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      decoration: TextDecoration.underline,
                    )),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],

          if(rideController.tripDetail?.parcelRefund?.status != RefundStatus.refunded)...[
            Container(width: Get.width,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.07),
              ),
              child: Text(
                rideController.tripDetail?.parcelRefund?.status == RefundStatus.pending ?
                'refund_request_send'.tr :
                rideController.tripDetail?.parcelRefund?.status == RefundStatus.approved ?
                'refund_request_approved'.tr :
                'refund_request_denied'.tr,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if(rideController.tripDetail?.parcelRefund?.status != RefundStatus.pending)...[
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    rideController.tripDetail?.parcelRefund?.status == RefundStatus.approved ?  'approval_note'.tr : 'denied_note'.tr,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).colorScheme.secondaryFixedDim),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    rideController.tripDetail?.parcelRefund?.status == RefundStatus.approved ?
                    rideController.tripDetail?.parcelRefund?.approvalNote ?? '' :
                    rideController.tripDetail?.parcelRefund?.denyNote ?? '',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  )
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],

            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.25))
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('product_approximate_price'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(PriceConverter.convertPrice(context, rideController.tripDetail?.parcelRefund?.parcelApproximatePrice ?? 0),style: textRobotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ]),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],

          Text('refund_reason'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6))),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(rideController.tripDetail?.parcelRefund?.reason ?? '',style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if(rideController.tripDetail?.parcelRefund?.customerNote?.isNotEmpty ?? false) CustomerNoteViewWidget(
            title: 'customer_note'.tr,
            details: rideController.tripDetail?.parcelRefund?.customerNote ?? '',
            edgeInsets: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          ),

          Text('proof_from_customer'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6))),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          GridView.builder(
              shrinkWrap: true,
              itemCount: rideController.tripDetail?.parcelRefund?.attachments?.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // number of items in each row
                  mainAxisSpacing: Dimensions.paddingSizeSmall, // spacing between rows
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  childAspectRatio: 2// spacing between columns
              ),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: ()=> Get.to(()=> ImageVideoViewer(attachments: rideController.tripDetail?.parcelRefund?.attachments,fromNetwork: true,clickedIndex: index)),
                  child: Stack(children: [
                    Container(height: 100,width: 150,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha: 0.05),
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                        child: (rideController.tripDetail?.parcelRefund?.attachments?[index].file ?? '').contains('.mp4') ?
                        Image.file(
                          File(rideController.thumbnailPaths![index]),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___)=> const SizedBox(),
                        ) : ImageWidget(
                          image: rideController.tripDetail?.parcelRefund?.attachments?[index].file ?? '',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),

                    if((rideController.tripDetail?.parcelRefund?.attachments?[index].file ?? '').contains('.mp4'))
                      Center(child: Image.asset(Images.playButtonIcon))
                  ]),
                );
              }
          ),
        ]),
      );
    });
  }
}
