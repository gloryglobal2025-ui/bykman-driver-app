import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final TripDetail? tripDetail;
  const PaymentDetailsWidget({super.key, required this.tripDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
        Dimensions.paddingSizeDefault,0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.2), width: .5),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'payment_details'.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),

            Text(
              tripDetail!.paymentMethod!.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ]),
        ),

        PaymentItemInfoWidget(
          icon: Images.farePrice, title: 'fare_price'.tr,
          amount: tripDetail!.distanceWiseFare ?? 0,
        ),

        if(tripDetail?.type != 'parcel')
          PaymentItemInfoWidget(
            icon: Images.idleHourIcon, title: 'idle_price'.tr,
            amount: tripDetail!.idleFee ?? 0,
          ),

        if(tripDetail?.type != 'parcel')
          PaymentItemInfoWidget(
            icon: Images.waitingPrice, title: 'delay_price'.tr,
            amount: tripDetail!.delayFee ?? 0,
          ),

        if(tripDetail?.type != 'parcel')
          PaymentItemInfoWidget(
            icon: Images.idleHourIcon, title: 'cancellation_price'.tr,
            amount: tripDetail!.cancellationFee ?? 0,
          ),

        PaymentItemInfoWidget(
          icon: Images.coupon, title: 'discount_amount'.tr,
          amount: tripDetail!.discountAmount ?? 0,
          discount: true, toolTipText: 'discount_applied_for_this_ride'.tr,
          subTitle: 'later_admin_will_pay_you_this_amount',
        ),

        PaymentItemInfoWidget(
          icon: Images.coupon, title: 'coupon_amount'.tr,
          amount: tripDetail!.couponAmount  ?? 0,
          discount: true, toolTipText: 'customer_applied_coupon_for_this_ride'.tr,
          subTitle: 'later_admin_will_pay_you_this_amount',
        ),

        PaymentItemInfoWidget(
          icon: Images.farePrice, title: 'tips'.tr,
          amount: tripDetail!.tips ?? 0,
        ),

        PaymentItemInfoWidget(
          icon: Images.farePrice, title: 'vat_tax'.tr,
          amount: tripDetail!.vatTax ?? 0,
        ),

        Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${'sub_total'.tr} (${'paid'.tr})',style: textSemiBold.copyWith(
            color: Theme.of(context).primaryColor,
          )),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
            child: Text(
              PriceConverter.convertPrice(context, double.parse(tripDetail!.paidFare!) - (tripDetail?.dueAmount ?? 0)),
              style: textRobotoBold.copyWith(
                color: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
          )
        ]),

        if(tripDetail?.type == 'parcel' && (tripDetail?.currentStatus == 'returning' || tripDetail?.currentStatus == 'returned'))...[
          const SizedBox(height: Dimensions.paddingSizeSmall),

          PaymentItemInfoWidget(
            icon: Images.returnDetailsIcon, title: '${'return_fee'.tr} (${tripDetail?.currentStatus == 'returning' ? 'due'.tr : 'paid'.tr})',
            amount: tripDetail!.returnFee ?? 0,
          )
        ],

        Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'payment_status'.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),

            Text(
              tripDetail!.paymentStatus!.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),

          ]),
        ),
      ]),
    );
  }
}
