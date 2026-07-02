import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomIconCardWidget extends StatefulWidget {
  final String icon;
  final String title;
  final Color? iconColor;
  final Color? backGroundColor;
  final Function()? onTap;
  const CustomIconCardWidget({
    super.key, required this.icon, this.onTap, required this.title,
    this.iconColor,this.backGroundColor
  });

  @override
  State<CustomIconCardWidget> createState() => _CustomIconCardWidgetState();
}

class _CustomIconCardWidgetState extends State<CustomIconCardWidget> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: .25, color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(100),
              color: widget.backGroundColor ?? Theme.of(context).cardColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: SizedBox(
                width: Dimensions.iconSizeLarge,
                child: Image.asset(widget.icon, color: widget.iconColor),
              ),
            ),
          ),
        ),

        Text(widget.title, style: textRegular),
      ]),
    );
  }

}