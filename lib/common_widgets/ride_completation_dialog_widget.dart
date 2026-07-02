import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_calculation_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/features/trip/screens/review_this_customer_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideCompletationDialogWidget extends StatelessWidget {
  const RideCompletationDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), // Smaller radius
      ),
      surfaceTintColor: Theme.of(context).cardColor,
      child: GetBuilder<RideController>(builder: (rideController){
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: ()=> Get.back(),
                child: Icon(Icons.highlight_remove_rounded,color: Theme.of(context).hintColor),
              ),
            ),

            const RouteCalculationWidget(fromEnd: true),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Image.asset(
              Get.find<RiderMapController>().isInside ?
              Images.completationDialogIcon :
              Images.completationDialogIcon2,
              height: 60,width: 60,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              Get.find<RiderMapController>().isInside ?
              '${'seems_you_reached_near_your'.tr} ${'destination'.tr}' :
              '${'seems_you_are_not_reached_near_your'.tr} ${'destination'.tr}',
              style: textRegular,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  width: Get.width * 0.3,
                  child: Center(child: Text('continue'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor))),
                ),
              ),

              rideController.isStatusUpdating ?
              SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
              InkWell(
                onTap: (){
                  if(rideController.tripDetail!.type != "parcel"){
                    rideController.tripStatusUpdate('completed', rideController.tripDetail!.id!, "trip_completed_successfully", '', []).then((value) async {
                      if(value.statusCode == 200){
                        rideController.getRideDetails(rideController.tripDetail!.id!);
                        rideController.getFinalFare(rideController.tripDetail!.id!).then((value){
                          if(value.statusCode == 200){
                            Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                            Get.off(()=> const PaymentReceivedScreen());
                          }
                        });
                      }
                    });

                  } else{
                    if(Get.find<RideController>().matchedMode != null && Get.find<RiderMapController>().isInside){
                      rideController.tripStatusUpdate('completed', rideController.tripDetail!.id!, "trip_completed_successfully",'', Get.find<OtpTimeCountController>().parcelDeliveryMultiPartImage).then((value) async {
                        if(value.statusCode == 200){
                          Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                          if(rideController.tripDetail!.parcelInformation!.payer == "sender"){
                            (!rideController.tripDetail!.isReviewed! && (Get.find<SplashController>().config?.reviewStatus ?? false)) ?
                            Get.offAll(()=>  ReviewThisCustomerScreen(tripId: rideController.tripDetail!.id?? '')) :
                            Get.offAll(() => const DashboardScreen());

                          }else{
                            rideController.getFinalFare(rideController.tripDetail!.id!).then((value){
                              if(value.statusCode == 200){
                                Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                                Get.off(()=> const PaymentReceivedScreen(fromParcel: true));
                              }
                            });
                          }
                        }
                      });
                    }else{
                      showCustomSnackBar("you_are_not_reached_destination".tr);
                    }

                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  width: Get.width * 0.3,
                  child: Center(child: Text('end'.tr,style: textRegular.copyWith(color: Theme.of(context).cardColor))),
                ),
              )
            ]),

            const SizedBox(height: Dimensions.paddingSizeDefault)
          ]),
        );
      }),
    );
  }
}


