
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_radio_button.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideCancellationList extends StatefulWidget {
  final bool isOngoing;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RideCancellationList({super.key, required this.isOngoing, required this.expandableKey});

  @override
  State<RideCancellationList> createState() => _RideCancellationListState();
}

class _RideCancellationListState extends State<RideCancellationList> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('why_do_you_want_to_cancel'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      GetBuilder<TripController>(builder: (tripController){
        int length = widget.isOngoing ?
        tripController.rideCancellationCauseList!.data!.ongoingRide!.length :
        tripController.rideCancellationCauseList!.data!.acceptedRide!.length;
        return Column(children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: length,
            physics: const NeverScrollableScrollPhysics(),padding: EdgeInsets.zero,
            itemBuilder: (context,index){
              return CustomRadioButton(
                  text: widget.isOngoing ?
                  tripController.rideCancellationCauseList!.data!.ongoingRide![index] :
                  tripController.rideCancellationCauseList!.data!.acceptedRide![index],
                  isSelected: tripController.rideCancellationCurrentIndex == index,
                  onTap: (){
                    tripController.setCancellationCurrentIndex(index);
                    setState(() {});
                    },
                  length: length
              );
            },
            separatorBuilder: (context,index){
              return const SizedBox();
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          TextField(
            cursorColor: Theme.of(context).primaryColor,
            controller: tripController.othersCancellationController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                borderSide: BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
              ),
              hintText: 'type_here_your_cancel_reason'.tr,
              hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
            ),
            readOnly: (widget.isOngoing ?
            tripController.rideCancellationCauseList!.data!.ongoingRide!.length-1 :
            tripController.rideCancellationCauseList!.data!.acceptedRide!.length -1) != tripController.rideCancellationCurrentIndex,
            maxLines: 2,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            onTap: () => Get.find<RideController>().focusOnBottomSheet(widget.expandableKey),
          )
        ]);
      }),
    ]);
  }
}
