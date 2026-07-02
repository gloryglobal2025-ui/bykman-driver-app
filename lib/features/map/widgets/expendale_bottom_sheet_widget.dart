import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/accepted_ride_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/calculating_sub_total_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/out_for_pickup_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/custom_icon_card_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_ride_request_card_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/screens/ride_request_list_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'stay_online_widget.dart';
import 'ride_ongoing_widget.dart';



class RiderBottomSheetWidget extends StatelessWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RiderBottomSheetWidget({super.key, required this.expandableKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(builder: (mapController) {
      return GetBuilder<RideController>(builder: (rideController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              borderRadius : const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                topRight : Radius.circular(Dimensions.paddingSizeDefault),
              ),
              boxShadow: [BoxShadow(
                  color: Theme.of(context).hintColor,
                  blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2)
              )],
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child : Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(height: 5, width: 30, decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  )),

                  if(mapController.currentRideState == RideState.initial)
                    const StayOnlineWidget(),

                  if(mapController.currentRideState == RideState.pending)
                    CustomerRideRequestCardWidget(rideRequest: rideController.tripDetail!),

                  if(mapController.currentRideState == RideState.accepted)
                    AcceptedRiderWidget(expandableKey: expandableKey),

                  if(mapController.currentRideState == RideState.outForPickup)
                    OutForPickupWidget(expandableKey: expandableKey),

                  if(mapController.currentRideState == RideState.ongoing)
                    RideOngoingWidget(tripId: rideController.tripDetail?.id ?? '',expandableKey: expandableKey),

                  if(mapController.currentRideState == RideState.completed)
                    const CalculatingSubTotalWidget(),

                  if(mapController.currentRideState == RideState.initial)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall,
                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:  [
                        rideController.isLoading ?
                        const LoaderWidget() :
                        CustomIconCardWidget(title: 'refresh'.tr,icon: Images.mIcon3,
                          onTap: () {
                            rideController.getPendingRideRequestList(1,isUpdate: true);
                          },
                        ),

                        CustomIconCardWidget(
                          title: 'leader_board'.tr,
                          icon: Images.mIcon2,
                          onTap: () => Get.to(()=> const LeaderboardScreen()),
                        ),

                        CustomIconCardWidget(
                          title: 'trip_request'.tr,
                          icon: Images.mIcon1,
                          onTap: () => Get.to(()=> const RideRequestScreen()),
                        ),
                      ]),
                    ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                ])
            ),
          );
        });
      });
    });
  }
}