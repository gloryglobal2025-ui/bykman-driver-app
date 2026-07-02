import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TripAcceptWarningDialogWidget extends StatelessWidget {
  final String? errorText;
  const TripAcceptWarningDialogWidget({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      insetPadding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: Dimensions.paddingSizeSmall, children: [
        Align(alignment: Alignment.topRight,
          child: InkWell(onTap: ()=> Get.back(), splashColor: Colors.transparent, child: Container(
            decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(
              Images.crossIcon,
              height: Dimensions.paddingSizeSmall,
              width: Dimensions.paddingSizeSmall,
            ),
          )),
        ),

        Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(50),
          ),
          height: 45,width: 45,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(
            Images.crossIcon,
            height: 20,
            width: 20,
            color: Theme.of(context).cardColor,
          ),
        ),

        Text('you_canot_accept_this_trip'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
          child: Text(errorText ?? '', style: textRegular.copyWith(color: Theme.of(context).hintColor), textAlign: TextAlign.center),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ButtonWidget(
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
          buttonText: 'got_it'.tr,
          onPressed: ()=> Get.back(),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      ]),
    );
  }
}
