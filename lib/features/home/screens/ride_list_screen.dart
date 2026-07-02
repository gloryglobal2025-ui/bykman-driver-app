import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_info_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/helper/extension_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideListScreen extends StatelessWidget {

  const RideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) => Future.delayed(const Duration(milliseconds: 50)).then((_){
          Get.offAll(()=> const DashboardScreen());
        }),
        child: Scaffold(
            appBar: AppBarWidget(title: 'ride_list'.tr, regularAppbar: true,),
            body: GetBuilder<RideController>(builder: (rideController){
              return (rideController.ongoingRideList == null || (rideController.ongoingRideList ?? []).isEmpty) ?
              const NoDataWidget(title: 'no_trip_found') :
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: rideController.ongoingRideList?.length ?? 0,
                  itemBuilder: (context, index){
                    return _TripCardWidget(rideController.ongoingRideList![index]);
                  });
            })
        ),
      ),
    );
  }
}

class _TripCardWidget extends StatelessWidget {
  final TripDetail rideRequest;
  const _TripCardWidget(this.rideRequest);

  @override
  Widget build(BuildContext context) {

    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(rideRequest.intermediateAddresses != null && rideRequest.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(rideRequest.intermediateAddresses!);
      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length>1){
        secondRoute = extraRoute[1];
      }
    }

    return GetBuilder<RideController>(builder: (rideController) {
      return InkWell(
        onTap: (){
          if (rideRequest.currentStatus == AppConstants.accepted || rideRequest.currentStatus == AppConstants.outForPickup) {
            Get.find<RideController>().getRideDetails(rideRequest.id!).then((value) {
              if (value.statusCode == 200) {
                Get.find<SafetyAlertController>().cancelDriverNeedSafetyStream();
                if(rideRequest.currentStatus == AppConstants.accepted) {
                  Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                }else{
                  Get.find<RiderMapController>().setRideCurrentState(RideState.outForPickup);
                }

                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().remainingDistance(rideRequest.id!,mapBound: true);
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });

          } else if ((rideRequest.currentStatus == AppConstants.completed || rideRequest.currentStatus == AppConstants.cancelled) && rideRequest.paymentStatus == AppConstants.unPaid) {
            Get.find<RideController>().getRideDetails(rideRequest.id!).then((value){
              if(value.statusCode == 200){
                Get.find<RideController>().getFinalFare(rideRequest.id!).then((value) {
                  if (value.statusCode == 200) {
                    Get.to(() => const PaymentReceivedScreen());
                  }
                });
              }
            });

          } else {
            _checkDriverNeedSafety(rideRequest);
            Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
            Get.find<RideController>().getRideDetails(rideRequest.id!).then((value) {
              if (value.statusCode == 200) {
                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().remainingDistance(rideRequest.id!,mapBound: true);
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });

          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
              border: Border.all(color: Theme.of(Get.context!).primaryColor,width: .35),
              boxShadow:[BoxShadow(
                color: Theme.of(Get.context!).primaryColor.withValues(alpha: .1),
                blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0),
              )],
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    'trip_type'.tr,
                    style: textRegular,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Flexible(
                    child: Row(children: [
                      if (rideRequest.currentStatus == AppConstants.accepted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(color: context.customThemeColors.upComingTagColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                        child: Text(
                          'upcoming'.tr,
                          style: textRegular.copyWith(color: Theme.of(Get.context!).cardColor),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Text(
                            rideRequest.type!.tr,
                            style: textRegular.copyWith(color: Theme.of(Get.context!).cardColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),

              RouteWidget(
                fromCard: true,
                pickupAddress: rideRequest.pickupAddress!,
                destinationAddress: rideRequest.destinationAddress!,
                extraOne: firstRoute, extraTwo: secondRoute, entrance: rideRequest.entrance??'',
              ),

              if(rideRequest.customer != null)
                CustomerInfoWidget(
                  fromTripDetails: false,
                  customer: rideRequest.customer!, fare: rideRequest.estimatedFare!,
                  customerRating: rideRequest.customerAvgRating!,
                ),
            ]),
          ),
        ),
      );
    });
  }
}

 void _checkDriverNeedSafety(TripDetail tripDetails){
  if(tripDetails.driverSafetyAlert != null){
    Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.afterSendAlert);
  }else{
    Get.find<SafetyAlertController>().checkDriverNeedSafety();
  }
 }