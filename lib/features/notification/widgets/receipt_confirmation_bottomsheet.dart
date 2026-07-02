import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReceiptConfirmationBottomsheet extends StatelessWidget {
  const ReceiptConfirmationBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeLarge), topLeft: Radius.circular(Dimensions.paddingSizeLarge))
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge * 2),

        Image.asset(Images.parcel, height: 50,width: 50),
        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Text(
            'parcel_returned_successfully'.tr, textAlign: TextAlign.center,
            style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge * 2.5),

      ]),
    );
  }
}
