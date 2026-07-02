import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReferralEarnBottomsheetWidget extends StatelessWidget {
  const ReferralEarnBottomsheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:const BorderRadius.only(
              topRight: Radius.circular(Dimensions.paddingSizeLarge),
              topLeft: Radius.circular(Dimensions.paddingSizeLarge),
            )
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            onTap: ()=> Get.back(),
            child: Align(alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

                child: Image.asset(Images.crossIcon,height: 10,width: 10),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text('how_referrer_earn_work'.tr,style: textBold),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Text('following_you_will_know'.tr,style: textRegular,textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(width: Get.width,
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('1. ', style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color
                )),

                Expanded(
                    child: Text('share_your_referral'.tr,style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color
                    ))
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('2. ', style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color
                )),

                Expanded(
                    child: Text('when_your_friend_or_family'.tr,style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color
                    ),)
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('3. ', style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color
                )),

                Expanded(
                  child: RichText(text: TextSpan(
                      text: '${'you_will_receive_a'.tr} ',
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color
                      ),
                      children: [
                        TextSpan(
                          text: '${PriceConverter.convertPrice(context, Get.find<ReferAndEarnController>().referralDetails?.data?.shareCodeEarning ?? 0)} ',
                          style: textRobotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        TextSpan(
                            text: '${'when_your_friend_complete'.tr} ',
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyMedium!.color
                            )
                        )
                      ]
                  )),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('4. ', style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyMedium!.color
                )),

                Expanded(
                    child: Text('your_friend_will'.tr,style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color
                    ),)
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

            ]),
          ),
        ]),
      ),
    );
  }
}