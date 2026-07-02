import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class MyActivityCardWidget extends StatelessWidget {
  final int index;
  final String title;
  final String icon;
  final int value;
  final Color color;

  const MyActivityCardWidget({super.key,  required this.index, required this.title, required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    int hour = 0, min =0;
    if(value>= 60){
      hour = (value/60).floor();
    }
    min = ((value % 60)).floor();

    return Padding(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
      child: Container(
        width: 150, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment : CrossAxisAlignment.start,children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text(
              title.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeLarge),
            )),

            SizedBox(width: Dimensions.iconSizeMedium, child: Image.asset(icon, color: color)),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(children: [
            Text('$hour:$min ', style: textSemiBold.copyWith(color: color, fontSize: Dimensions.fontSizeExtraLarge)),

            Text('hr', style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeExtraLarge)),
          ]),
        ]),
      ),
    );
  }
}