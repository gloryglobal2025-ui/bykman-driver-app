import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class WalletAmountTypeCardWidget extends StatelessWidget {
  final String icon;
  final double amount;
  final String title;
  final bool haveBorderColor;
  const WalletAmountTypeCardWidget({
    super.key, required this.icon,
    required this.amount, required this.title,
    this.haveBorderColor = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
        0, Dimensions.paddingSizeSmall,
      ),
      child: Container(width: 180, padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          border: Border.all(
            color:haveBorderColor ?
            Theme.of(context).primaryColor :
            Theme.of(context).disabledColor.withValues(alpha: 0.30),
            width: 1,
          ),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 40,child: Image.asset(icon)),

          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            child: Text(PriceConverter.convertPrice(context, amount),
                style: textSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8) : null
                ),
            ),
          ),

          Text(title, style: textSemiBold.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: haveBorderColor ?
            Theme.of(context).textTheme.bodyMedium!.color :
            Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)
          )),
        ]),
      ),
    );
  }
}
