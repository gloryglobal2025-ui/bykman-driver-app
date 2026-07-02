import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'route_widget.dart';

class ParcelRequestCardWidget extends StatelessWidget {
  final TripDetail rideRequest;
  final String? pickupTime;
  final int? index;
  const ParcelRequestCardWidget({super.key, required this.rideRequest,  this.pickupTime, this.index});

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

    return
      GetBuilder<RideController>(builder: (rideController) {
        return InkWell(
          onTap: () {
            if (rideRequest.currentStatus == AppConstants.accepted || rideRequest.currentStatus == AppConstants.outForPickup) {
              Get.find<RideController>().getRideDetails(rideRequest.id!).then((value) {
                if (value.statusCode == 200) {
                  if(rideRequest.currentStatus == AppConstants.outForPickup){
                    Get.find<RiderMapController>().setRideCurrentState(RideState.outForPickup);
                  }else{
                    Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                  }
                  Get.find<RiderMapController>().setMarkersInitialPosition();
                  Get.find<RideController>().remainingDistance(rideRequest.id!,mapBound: true);
                  Get.find<RideController>().updateRoute(false, notify: true);
                  Get.to(() => const MapScreen(fromScreen: 'splash'));
                }
              });

            } else if (rideRequest.currentStatus == "completed" && rideRequest.paymentStatus == 'unpaid') {
              Get.find<RideController>().getFinalFare(rideRequest.id!).then((value) {
                if (value.statusCode == 200) {
                  Get.to(() => const PaymentReceivedScreen());
                }
              });

            }else if(rideRequest.currentStatus == "returning" ){
              Get.to(()=> TripDetails(tripId: rideRequest.id!));
            } else {
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
          child: Padding(padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeExtraSmall),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                border: Border.all(color: Theme.of(Get.context!).primaryColor, width: .35),
                boxShadow: [BoxShadow(
                  color: Theme.of(Get.context!).primaryColor.withValues(alpha: .1),
                  blurRadius: 1, spreadRadius: 1, offset: const Offset(0, 0),
                )],
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('trip_type'.tr, style: textRegular.copyWith(color: Theme.of(Get.context!).primaryColor)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      ),
                      child: Text(rideRequest.type!.tr, style: textRegular.copyWith(color: Theme.of(Get.context!).cardColor)),
                    )
                  ]),
                ),

                RouteWidget(
                  fromCard: true,
                  pickupAddress: rideRequest.pickupAddress!,
                  destinationAddress: rideRequest.destinationAddress!,
                  extraOne: firstRoute,
                  extraTwo: secondRoute,
                  entrance: rideRequest.entrance ?? '',
                ),

                if(rideRequest.customer != null)
                  CustomerInfoWidget(
                    fromTripDetails: false,
                    customer: rideRequest.customer!,
                    fare: rideRequest.estimatedFare!,
                    customerRating: rideRequest.customerAvgRating!,
                  ),
                

                // (rideController.isLoading && (rideRequest.id == rideController.loadingId))?
                // SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(
                //     Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
                //     Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                //   ),
                //   child: SizedBox(width: Get.width, child: Row(children: [
                //     if(rideRequest.currentStatus == "ongoing")
                //       Expanded(child: ButtonWidget(buttonText: 'complete'.tr,
                //         radius: Dimensions.paddingSizeSmall,
                //         onPressed: () async {
                //         await rideController.checkDriverReachedDestination(rideRequest.id!);
                //           if (rideRequest.paymentStatus == 'paid') {
                //             Get.dialog(ConfirmationDialogWidget(
                //               icon: Images.logo,
                //               description: 'are_you_sure'.tr,
                //               onYesPressed: () {
                //                 if (Get.find<RideController>().matchedMode != null && Get.find<RiderMapController>().isInside) {
                //                   Get.find<RideController>().tripStatusUpdate('completed', rideRequest.id!, "trip_completed_successfully", '').then((value) async { ///TODO
                //                     if (value.statusCode == 200) {
                //                       Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                //                       if (Get.find<SplashController>().config!.reviewStatus! && !rideRequest.isReviewed!) {
                //                         Get.offAll(() => ReviewThisCustomerScreen(tripId: rideRequest.id!));
                //                       } else {
                //                         Get.off(() => const DashboardScreen());
                //                       }
                //                     }
                //                   });
                //
                //                 } else {
                //                   Get.back();
                //                   showCustomSnackBar("you_are_not_reached_destination".tr);
                //
                //                 }
                //               },
                //             ), barrierDismissible: false);
                //
                //           } else {
                //             if (rideRequest.parcelInformation!.payer == 'sender' && rideRequest.paymentStatus == 'unpaid') {
                //               Get.find<RideController>().getFinalFare(rideRequest.id!).then((value) {
                //                 if (value.statusCode == 200) {
                //                   Get.to(() => const PaymentReceivedScreen(fromParcel: true));
                //                 }
                //               });
                //
                //             } else {
                //               if (Get.find<RideController>().matchedMode != null && Get.find<RiderMapController>().isInside) {
                //                 rideController.tripStatusUpdate('completed', rideRequest.id!, "trip_completed_successfully", '', []).then((value) async {
                //                   if (value.statusCode == 200) {
                //                     Get.find<RideController>().getFinalFare(rideRequest.id!).then((value) {
                //                       if (value.statusCode == 200) {
                //                         Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                //                         Get.to(() => const PaymentReceivedScreen());
                //                       }
                //                     });
                //                   }
                //                 });
                //
                //               } else {
                //                 showCustomSnackBar("you_are_not_reached_destination".tr);
                //
                //               }
                //             }
                //           }
                //         },
                //       )),
                //   ])),
                // )
              ]),
            ),
          ),
        );
      });
  }
}

