import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/wallet_amount_type_card_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class TransactionCardButtonWidget extends StatelessWidget {
  final int tabIndex;
  const TransactionCardButtonWidget({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController){
      return GetBuilder<ProfileController>(builder: (profileController) {
        return Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
          child: SizedBox(
            height: ((walletController.walletTypeIndex == 0 && tabIndex == 0) || (walletController.walletTypeIndex == 2)) ? 150 : 10,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                if(walletController.walletTypeIndex == 0 && tabIndex == 0)...[
                  GestureDetector(
                    onTap: walletController.isLoading ? null : (){
                      walletController.setSelectedHistoryIndex(1, true);
                    },
                    child: WalletAmountTypeCardWidget(icon: Images.pendingWithdrawn,
                      amount: profileController.profileInfo?.wallet?.pendingBalance ?? 0,
                      title: 'pending_withdrawn'.tr,
                      haveBorderColor: walletController.selectedHistoryIndex == 1 ? true : false,
                    ),
                  ),

                  GestureDetector(
                    onTap: walletController.isLoading ? null : (){
                      walletController.setSelectedHistoryIndex(2, true);
                    },
                    child: WalletAmountTypeCardWidget(icon: Images.allreadyWithdrawnIcon,
                      amount: profileController.profileInfo?.wallet?.totalWithdrawn ?? 0,
                      title: 'already_withdrawn'.tr,
                      haveBorderColor: walletController.selectedHistoryIndex == 2 ? true : false,
                    ),
                  ),

                  GestureDetector(
                    onTap: walletController.isLoading ? null : (){
                      walletController.setSelectedHistoryIndex(3, true);
                    },
                    child: WalletAmountTypeCardWidget(icon: Images.paidBalanceIcon,
                      amount:profileController.profileInfo?.paidAmount ?? 0,
                      title: 'paid_amount'.tr,
                      haveBorderColor: walletController.selectedHistoryIndex == 3 ? true : false,
                    ),
                  ),

                  GestureDetector(
                    onTap: walletController.isLoading ? null : (){
                      walletController.setSelectedHistoryIndex(4, true);
                    },
                    child: WalletAmountTypeCardWidget(icon: Images.walletBalanceIcon,
                      amount: profileController.profileInfo?.levelUpRewardAmount ?? 0,
                      title: 'level_up_reward'.tr,
                      haveBorderColor: walletController.selectedHistoryIndex == 4 ? true : false,
                    ),
                  ),
                ],

                if(walletController.walletTypeIndex == 2)...[
                  if(profileController.profileInfo != null && profileController.profileInfo!.wallet != null)
                    WalletAmountTypeCardWidget(icon: Images.totalEarning,
                      amount: profileController.profileInfo?.totalEarning ?? 0,
                      title: 'total_earning'.tr,
                    ),

                  WalletAmountTypeCardWidget(icon: Images.pendingWithdrawn ,
                    amount: profileController.profileInfo?.tripIncome ?? 0,
                    title: 'trips_income'.tr,
                  ),

                  WalletAmountTypeCardWidget(icon: Images.withdrawMoneyIcon,
                    amount: profileController.profileInfo?.totalTips ?? 0,
                    title: 'total_tips'.tr,
                  ),

                  WalletAmountTypeCardWidget(icon: Images.totalCommissionIcon,
                    amount: profileController.profileInfo?.totalCommission ?? 0,
                    title: 'total_commission'.tr,
                  ),
                ]

              ],
            ),
          ),
        );
      });
    });
  }
}
