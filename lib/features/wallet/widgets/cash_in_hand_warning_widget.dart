import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payment_method_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/extension_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CashInHandWarningWidget extends StatelessWidget {
  const CashInHandWarningWidget({super.key});

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
          if(Get.find<ProfileController>().isCashInHandHoldAccount)...[
            Row(children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9), size: 18),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('your_account_is_on_hold'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9))),

              const Spacer(),

              InkWell(
                onTap: ()=> Get.find<ProfileController>().removeCashInHandWarnings(),
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

            RichText(text: TextSpan(
              text: '${'your_account_is_on_hold_for_exceeding'.tr} ',
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = (){
                      double payableBalance = (Get.find<ProfileController>().profileInfo!.wallet!.payableBalance! - Get.find<ProfileController>().profileInfo!.wallet!.receivableBalance!);

                      if(payableBalance >= (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0)){
                        Get.bottomSheet(PaymentMethodBottomsheetWidget(payableBalance: payableBalance), isScrollControlled: true);
                      }else{
                        showCustomSnackBar('${'minimum_payment_amount'.tr} ${PriceConverter.convertPrice(context, (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0))}');
                      }
                    },
                    text: 'pay_now'.tr, style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  decoration: TextDecoration.underline,
                )),
              ],
            ))
          ]
          else...[
            Row(children: [
              Container(
                height: 16, width: 16,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                    shape: BoxShape.circle
                ),
                padding: EdgeInsets.all(Dimensions.paddingSizeTiny),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeTiny),
                  child: Image.asset(Images.crossIcon, color: Theme.of(context).cardColor.withValues(alpha: 0.7)),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('${'attention_please'.tr} !', style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall))
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            RichText(text: TextSpan(
              text: '${'looks_like_your_limit_to_hold_cash_will_be'.tr} ',
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color),
              children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = (){
                      double payableBalance = (Get.find<ProfileController>().profileInfo!.wallet!.payableBalance! - Get.find<ProfileController>().profileInfo!.wallet!.receivableBalance!);

                      if(payableBalance >= (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0)){
                        Get.bottomSheet(PaymentMethodBottomsheetWidget(payableBalance: payableBalance), isScrollControlled: true);
                      }else{
                        showCustomSnackBar('${'minimum_payment_amount'.tr} ${PriceConverter.convertPrice(context, (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0))}');
                      }
                    },
                    text: 'pay_now'.tr, style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  decoration: TextDecoration.underline,
                )),
              ],
            ))
          ]
        ]),
      ),
    );
  }
}
