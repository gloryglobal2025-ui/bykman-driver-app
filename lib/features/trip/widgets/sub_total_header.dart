import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_safety_sheet_details_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SubTotalHeaderTitle extends StatefulWidget {
  final String title;
  final double? width;
  final Color? color;
  final double? amount;

  const SubTotalHeaderTitle({super.key, required this.title, this.width, this.color, this.amount});

  @override
  State<SubTotalHeaderTitle> createState() => _SubTotalHeaderTitleState();
}

class _SubTotalHeaderTitleState extends State<SubTotalHeaderTitle> {
  JustTheController toolTipController = JustTheController();

  @override
  void initState() {
    if(Get.find<RideController>().tripDetail?.driverSafetyAlert != null){
      showToolTips();
    }
    super.initState();
  }


  @override
  void dispose() {
    toolTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(width: widget.width ?? Get.width,
        transform: Matrix4.translationValues(0, -30, 0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
            border: Border.all(width: .5, color: Theme.of(context).primaryColor)
        ),
        child: Column(children: [
          Stack(children: [
            Row(
              mainAxisAlignment:widget.amount != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                  child: Text(widget.title, style: textBold.copyWith(
                    color: widget.color ?? Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeLarge,
                  )),
                ),

                if(widget.amount != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                    child: Text(PriceConverter.convertPrice(context, widget.amount!), style: textRobotoBold.copyWith(
                      color: widget.color ?? Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                  ),
              ],
            ),

            if(Get.find<RideController>().tripDetail?.driverSafetyAlert != null )
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault, top: 10),
                child: JustTheTooltip(
                  backgroundColor: Get.isDarkMode ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).textTheme.bodyMedium!.color,
                  controller: toolTipController,
                  preferredDirection: AxisDirection.right,
                  tailLength: 10,
                  tailBaseWidth: 20,
                  content: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Text(
                      'tap_to_see_safety_details'.tr,
                      style: textRegular.copyWith(
                        color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: ()=> Get.bottomSheet(
                      isScrollControlled: true,
                      TripSafetySheetDetailsWidget(tripDetails: Get.find<RideController>().tripDetail),
                      backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                    ),
                    child: Image.asset(Images.safelyShieldIcon3,height: 30,width: 30),
                  ),
                ),
              ),
            )
          ]),

          if(Get.find<RideController>().tripDetail?.currentStatus == 'returning' && Get.find<RideController>().tripDetail?.returnTime != null )...[
            Container(
                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15)
                ),
                child: Text.rich(TextSpan(
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8)), children:  [
                      TextSpan(
                        text: 'parcel_return_estimated_time_is'.tr,
                        style: textRegular.copyWith(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),

                  TextSpan(
                    text: ' ${DateConverter.stringToLocalDateTime(Get.find<RideController>().tripDetail!.returnTime!)}',
                    style: textSemiBold.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                  ),

                ]), textAlign: TextAlign.center)
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault)
          ]

        ]),
      ),
    );
  }

  void showToolTips(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(const Duration(milliseconds: 500)).then((_){
        toolTipController.showTooltip();
      });
    });
  }

}

