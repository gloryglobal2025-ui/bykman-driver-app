import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payment_method_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/point_to_wallet_money_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/withdraw_bottom_sheet_widget.dart';

class WalletMoneyAmountWidget extends StatelessWidget {
  const  WalletMoneyAmountWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WalletController>(builder: (walletController) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        double receivableBalance = _calculateReceivableBalanceBalance(
          profileController.profileInfo?.wallet?.receivableBalance ?? 0,
          profileController.profileInfo?.wallet?.payableBalance ?? 0,
        );
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimensions.paddingSizeDefault,0,
            Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
          ),
          child: InkWell(
              onTap: (){
                if(walletController.walletTypeIndex == 1){
                  if(Get.find<SplashController>().config!.conversionStatus!){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: PointToWalletMoneyWidget())
                    );

                  }else{
                    showCustomSnackBar('point_conversion_is_currently_unavailable'.tr);
                  }

                }else if(walletController.walletTypeIndex == 0){
                  if(receivableBalance > 0 ){
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) => const WithdrawRequestWidget(),
                    );
                  }else{
                    double payableBalance = (profileController.profileInfo!.wallet!.payableBalance! - profileController.profileInfo!.wallet!.receivableBalance!);

                    if(payableBalance >= (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0)){
                      Get.bottomSheet(PaymentMethodBottomsheetWidget(payableBalance: payableBalance), isScrollControlled: true);
                    }else{
                      showCustomSnackBar('${'minimum_payment_amount'.tr} ${PriceConverter.convertPrice(context, (Get.find<SplashController>().config?.cashInHandMinAmountToPay ?? 0))}');
                    }
                  }
                }
              },
              child: Container(width: Get.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSize),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    walletController.walletTypeIndex == 0  ?
                    receivableBalance> 0 ?
                    'withdraw_able_balance'.tr :
                    'payable_balance'.tr :
                    'convert_able_point'.tr,
                    style: textBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        // color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.9) : null
                    ),
                  ),

                  Text(
                    walletController.walletTypeIndex == 0  ?
                    receivableBalance > 0 ?
                    'you_can_send_withdraw_request'.tr :
                    'you_have_to_pay'.tr :
                    'convert_loyalty_point_to_wallet'.tr,
                    style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8) : null),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSize),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Image.asset(Images.withdrawMoneyIcon,height: 30,width: 30),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        walletController.walletTypeIndex == 0 ?
                        Text(
                          receivableBalance > 0 ?
                          PriceConverter.convertPrice(context, receivableBalance) :
                          PriceConverter.convertPrice(
                            context,
                            (profileController.profileInfo!.wallet!.payableBalance! -
                                profileController.profileInfo!.wallet!.receivableBalance!),
                          ),
                          style: textRobotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ) :
                        Text(
                          profileController.profileInfo?.loyaltyPoint.toString() ?? '0',
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),
                      ]),

                      (walletController.walletTypeIndex == 0 && !(receivableBalance > 0)) ?
                      (Get.find<SplashController>().config?.cashInHandSetupStatus ?? false) ?
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text('pay_now'.tr, style: textRegular.copyWith(color: Theme.of(context).cardColor)),
                      ) :
                      const SizedBox() :
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child:  Icon(Icons.arrow_forward_ios,size: Dimensions.iconSizeMedium,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      )

                    ]),
                  )
                ]),
              )
          ),
        );
      });
    });
  }

  double _calculateReceivableBalanceBalance(double receivableBalance, double payableBalance){
    return receivableBalance - payableBalance;
  }
}
