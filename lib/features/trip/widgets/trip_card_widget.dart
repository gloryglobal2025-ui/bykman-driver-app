import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';

import '../screens/payment_received_screen.dart';

class TripCard extends StatelessWidget {
  final TripDetail tripModel;
  const TripCard({super.key, required this.tripModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(tripModel.currentStatus == AppConstants.accepted || tripModel.currentStatus == AppConstants.ongoing || tripModel.currentStatus == AppConstants.outForPickup){
          if(tripModel.currentStatus == AppConstants.accepted || tripModel.currentStatus == AppConstants.outForPickup){
            Get.find<RideController>().getRideDetails(tripModel.id!).then((value){
              if(value.statusCode == 200){
                if(tripModel.currentStatus == AppConstants.outForPickup){
                  Get.find<RiderMapController>().setRideCurrentState(RideState.outForPickup);
                }else{
                  Get.find<RiderMapController>().setRideCurrentState(RideState.accepted);
                }

                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });
          }else if(tripModel.currentStatus == AppConstants.completed && tripModel.paymentStatus == AppConstants.unPaid){
            Get.find<RideController>().getFinalFare(tripModel.id!).then((value){if(value.statusCode == 200){
              Get.to(()=> const PaymentReceivedScreen());
            }});
          } else{
            Get.find<RiderMapController>().setRideCurrentState(RideState.ongoing);
            Get.find<RideController>().getRideDetails(tripModel.id!).then((value){
              if(value.statusCode == 200){
                Get.find<RiderMapController>().setMarkersInitialPosition();
                Get.find<RideController>().updateRoute(false, notify: true);
                Get.to(() => const MapScreen(fromScreen: 'splash'));
              }
            });
          }
        }else{
          Get.to(()=> TripDetails(tripId: tripModel.id!));
        }
      },
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            Stack(children: [
              Container(
                width: 90, height: Get.height * 0.11,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                ),
                child: Column(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(height: 50,
                        tripModel.type == AppConstants.parcel ?
                        Images.parcel :
                        tripModel.vehicleCategory != null ?
                        tripModel.vehicleCategory!.type == "car"?
                        Images.car :
                        Images.bike :
                        Images.car,
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  if(tripModel.currentStatus == AppConstants.accepted)
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeSmall), bottomRight: Radius.circular(Dimensions.paddingSizeSmall))
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Center(child: Text('upcoming'.tr, style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall))),
                  ),

                  if(tripModel.currentStatus != AppConstants.accepted)...[
                    Text(
                      tripModel.type != AppConstants.parcel ?
                      tripModel.vehicleCategory != null ?
                      tripModel.vehicleCategory!.name!
                          : '' :
                      'parcel'.tr,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall)
                  ]
                ]),
              ),

              Positioned(
                right: 0,
                child: Container(
                  height: 20,width: 20,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color:  tripModel.currentStatus == AppConstants.cancelled ?
                      Theme.of(context).colorScheme.error.withValues(alpha: 0.15) :
                      tripModel.currentStatus == AppConstants.completed ?
                      Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.15) :
                      tripModel.currentStatus == 'returning' ?
                      Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.15) :
                      tripModel.currentStatus == 'returned' ?
                      Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.15) :
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15) ,
                      shape: BoxShape.circle
                  ),
                  child: tripModel.currentStatus == AppConstants.cancelled ?
                  Image.asset(Images.crossIcon,color: Theme.of(context).colorScheme.error) :
                  tripModel.currentStatus == AppConstants.completed ?
                  Image.asset(Images.selectedIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                  tripModel.currentStatus == 'returning' ?
                  Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceContainer) :
                  tripModel.currentStatus == 'returned' ?
                  Image.asset(Images.returnIcon,color: Theme.of(context).colorScheme.surfaceTint) :
                  Image.asset(Images.ongoingMarkerIcon,color: Theme.of(context).colorScheme.primaryContainer),
                ),
              )
            ]),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${'trip_id'.tr}: ${tripModel.refId}',
                  style: textRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .6),
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeTiny)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeTiny),
                  child: Text(DateConverter.isoStringToTripDetailsDateTime(tripModel.createdAt!),
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                )
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(spacing: Dimensions.paddingSizeTiny, children: [
                Image.asset(
                  Images.currentLocation,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  height: 14, width: 14,
                ),

                Expanded(child: Text(
                    tripModel.type == AppConstants.parcel ?
                    tripModel.parcelInformation?.parcelCategoryName ?? '' :
                    tripModel.destinationAddress ?? '',overflow: TextOverflow.ellipsis,
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7))
                ))
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(spacing: Dimensions.paddingSizeTiny, children: [
                Image.asset(
                  Images.customerDestinationIcon,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 14, width: 14,
                ),

                Expanded(child: Text(
                    tripModel.pickupAddress ?? '',overflow: TextOverflow.ellipsis,
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7))
                ))
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  '${'total'.tr} ${PriceConverter.convertPrice(context, double.parse( tripModel.paidFare != '0' ? (tripModel.paidFare ?? '0') : (tripModel.estimatedFare ?? '0')))}',
                  style: textRobotoBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),

                if(tripModel.driverSafetyAlert != null)
                Image.asset(Images.safelyShieldIcon1,height: 20,width: 20),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ])),

          ]),
        ),
      ]),
    );
  }
}
