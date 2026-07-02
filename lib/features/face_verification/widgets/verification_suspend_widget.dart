import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/extension_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class VerificationSuspendWidget extends StatelessWidget {
  const VerificationSuspendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height * 0.1, right: 0, left: 0,
      child: Container(
        decoration: BoxDecoration(
            color: context.customThemeColors.warningBackGroundColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9), size: 18),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('your_account_has_been_suspend'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9))),

              const Spacer(),

              InkWell(
               // onTap: ()=> Get.find<ProfileController>().removeCashInHandWarnings(),
                child: Container(
                  height: 16, width: 16,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(4),
                  child: Image.asset(Images.crossIcon, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                ),
              )
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            
            Row(children: [
              Expanded(child: Text(
                'your_account_is_suspend_due_to_failed_verification'.tr,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text('verify_now'.tr, style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.surfaceContainer
              ))
            ]),
        ]),
      ),
    );
  }
}
