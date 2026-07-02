import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class FaceVerifyingDialog extends StatelessWidget {

  const FaceVerifyingDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha:0.5),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Text('verifying'.tr, style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor)),

        LoadingOverlayPro(
          isLoading: true,
          backgroundColor: Colors.transparent,
          progressIndicator: LoadingBouncingLine.circle(
            borderColor: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).cardColor,
            size: 40,
          ),
          child: SizedBox(),
        )

      ])),
    );
  }
}