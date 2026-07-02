import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/income_statement_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/loyalty_point_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/payable_transaction_list_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widgets/pending_settled_list_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class HistoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  final int tabIndex;
  const HistoryListWidget({super.key, required this.scrollController, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Text(
              (walletController.walletTypeIndex == 0 || walletController.walletTypeIndex == 2) ?
              'transaction_history'.tr :
              'point_gained_history'.tr,
              style: textBold.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        if(walletController.walletTypeIndex == 0 && tabIndex == 0)
          (walletController.selectedHistoryIndex == 1 || walletController.selectedHistoryIndex == 2) ?
          PendingSettledListWidget(
            walletController: walletController,
            scrollController: scrollController,
          ) :
          PayableTransactionListWidget(
            walletController: walletController,
            scrollController: scrollController,
          ),

        if(walletController.walletTypeIndex == 1)
          LoyaltyPointTransactionListWidget(walletController: walletController),

        if(walletController.walletTypeIndex == 2)
          IncomeStatementListWidget(
            walletController: walletController,
            scrollController: scrollController,
          ),

        if(walletController.walletTypeIndex == 0 && (tabIndex == 1 || tabIndex == 2))
          PayableTransactionListWidget(
            walletController: walletController,
            scrollController: scrollController,
          )

      ]);
    });
  }
}
