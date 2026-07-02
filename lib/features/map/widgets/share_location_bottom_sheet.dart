import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/snackbar_widget.dart';

class ShareLocationBottomSheet extends StatelessWidget {
  const ShareLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeLarge,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
      ),
      child: GetBuilder<RideController>(builder: (rideController){
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 7, width: 30, decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          )),
          // Close Button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withAlpha(50),
                      shape: BoxShape.circle
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Image.asset(Images.crossIcon, width: 10, height: 10, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.75))
              ),
            ),
          ),
          // Icon
          Image.asset(Images.mapShareLocation, height: 60, width: 60),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              'share_live_location'.tr,
              textAlign: TextAlign.center,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Text(
            'live_location_link'.tr,
            style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSize),

          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              strokeWidth: 1,
              dashPattern: const [5, 5],
              color: Theme.of(context).hintColor,
              radius: const Radius.circular(Dimensions.radiusExtraLarge),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              child: Row(children: [
                Expanded(child: Text(
                  rideController.tripDetail?.driverLocationUrl ?? '',
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Container(
                  height: 30,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: rideController.tripDetail?.driverLocationUrl ?? ''));
                      snackBarWidget('link_copied'.tr, isError: false);
                    },
                    child: Center(child: Image.asset(
                      Images.copyIcon, width: 18, height: 18,
                      fit: BoxFit.contain, color: Theme.of(context).cardColor,
                    )),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSize),

          // Note
          Text(
            'note_link_expire'.tr,
            textAlign: TextAlign.center,
            style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // OR divider
          Text(
            'OR'.tr,
            style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Share Button
          ElevatedButton(
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(
                  uri: Uri.parse(rideController.tripDetail?.driverLocationUrl ?? ''),
                  subject: 'share_live_location'.tr,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge,
                vertical: Dimensions.paddingSizeSmall,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: Dimensions.paddingSizeSmall,
              children: [
                Image.asset(Images.shareLocationBtn, width: 18, height: 18, color: Theme.of(context).cardColor),

                Text(
                  'share_location'.tr,
                  style: textMedium.copyWith(color: Theme.of(context).cardColor),
                ),
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
