import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/digital_payment_screen.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PaymentMethodBottomsheetWidget extends StatelessWidget {
  final double payableBalance;
  const PaymentMethodBottomsheetWidget({super.key, required this.payableBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.9),
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeDefault), topRight: Radius.circular(Dimensions.paddingSizeDefault))
      ),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
      child: GetBuilder<WalletController>(builder: (walletController){
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 30, height: Dimensions.paddingSizeTiny, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Image.asset(Images.withdrawMoneyIcon,height: 30,width: 30),

          Text(PriceConverter.convertPrice(context, payableBalance), style: textRobotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Align(alignment: Alignment.centerLeft, child: Text('payment_method'.tr, style: textSemiBold)),

          Row(children: [
            Text('pay_via_online'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

            Text(' (${'fast_and_secure_way'.tr})', style: textMedium.copyWith(fontSize: 8))
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          (walletController.paymentGateways ?? []).isNotEmpty ?
          Flexible(child: ListView.separated(
            itemCount: walletController.paymentGateways?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (ctx, index){
              return InkWell(
                onTap: ()=> walletController.setDigitalPaymentType(index, walletController.paymentGateways![index].gateway ?? ''),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      index == walletController.paymentGatewayIndex ?
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Icon(Icons.check, color: Colors.white,size: 16),
                      ) :
                      Container(
                        height: 16,width: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Theme.of(context).hintColor),
                        ),
                        child: const SizedBox(),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text('${walletController.paymentGateways![index].gatewayTitle}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                    ]),

                    ImageWidget(image: '${AppConstants.baseUrl}/storage/app/public/payment_modules/gateway_image/${walletController.paymentGateways![index].gatewayImage}', height: 16, fit: BoxFit.contain)
                  ]),
                ),
              );
            },
            separatorBuilder: (ctx, index){
              return SizedBox(height: Dimensions.paddingSizeSmall);
            },
          )) :
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text(
              'currently_no_payment_method_is_available'.tr,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ButtonWidget(
              radius: Dimensions.radiusDefault,
              onPressed:(walletController.paymentGateways ?? []).isNotEmpty ? (){
                Get.back();
                Get.to(()=> DigitalPaymentScreen(paymentMethod: walletController.gateWay, totalAmount: payableBalance.toStringAsFixed(int.parse(Get.find<SplashController>().config!.currencyDecimalPoint ?? '1'))));
              } : null,
              buttonText: 'select'.tr
          )
        ]);
      }),
    );
  }
}
