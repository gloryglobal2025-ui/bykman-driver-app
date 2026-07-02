import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final int length;

  const CustomRadioButton({super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(child: Text(
            text,
            style: TextStyle(
              color: !isSelected ? Get.isDarkMode ?
              Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5) :
              Theme.of(context).hintColor :
              Get.isDarkMode ?
              Theme.of(context).textTheme.bodyMedium!.color :
              Colors.black,
              fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault,
            ),
          )),
          const SizedBox(width: 8),

          isSelected ?
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
            child: const Icon(Icons.check, color: Colors.white,size: 16),
          ) :
          Container(
            height: 16,width: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              border: Border.all(color: Theme.of(context).hintColor),
            ),
            child: const SizedBox(),
          )
        ]),
      ),
    );
  }
}