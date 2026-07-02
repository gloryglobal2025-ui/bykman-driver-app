import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_date_picker.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_time_picker.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/ride_completation_dialog_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button/slider_buttion_widget.dar.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/home/screens/ride_list_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_image_proof_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/ride_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_calculation_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/user_details_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';

class RideOngoingWidget extends StatefulWidget {
  final String tripId;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RideOngoingWidget({super.key, required this.tripId, required this.expandableKey});

  @override
  State<RideOngoingWidget> createState() => _RideOngoingWidgetState();
}

class _RideOngoingWidgetState extends State<RideOngoingWidget> {
  bool isFinished = false;
  int currentState = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return currentState == 0 ?
      rideController.tripDetail != null ?
      _OngoingTripWidget(callBack: (){
        currentState = 1;
        widget.expandableKey.currentState?.expand();
        setState(() {});
      }) :
      const SizedBox() :
      currentState == 1 ?
      rideController.tripDetail?.type != AppConstants.parcel ?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text('your_trip_is_ongoing'.tr,style: textSemiBold.copyWith(
            color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall,
          )),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          RideCancellationList(isOngoing: true,expandableKey: widget.expandableKey),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(children: [
            Expanded(child: ButtonWidget(
              buttonText: 'no_continue_trip'.tr,
              showBorder: true,
              transparent: true,
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              radius: Dimensions.paddingSizeSmall,
              onPressed: (){
                currentState = 0;
                setState(() {});
              },
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: ButtonWidget(
              buttonText: 'submit'.tr,
              showBorder: true,
              transparent: true,
              textColor: Get.isDarkMode ? Colors.white : Colors.black,
              borderColor: Theme.of(context).hintColor,
              radius: Dimensions.paddingSizeSmall,
              onPressed: (){
                rideController.tripStatusUpdate(
                  'cancelled', rideController.tripDetail!.id!,
                  "trip_cancelled_successfully",
                  (Get.find<TripController>().rideCancellationCauseList!.data!.ongoingRide!.length - 1) == Get.find<TripController>().rideCancellationCurrentIndex ?
                  Get.find<TripController>().othersCancellationController.text :
                  Get.find<TripController>().rideCancellationCauseList!.data!.ongoingRide![Get.find<TripController>().rideCancellationCurrentIndex], []
                ).then((value) async {
                  if(value.statusCode == 200){
                    rideController.ongoingTripList().then((value){
                      if((rideController.ongoingTrip ?? []).isEmpty){
                        Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                        Get.offAll(()=> const DashboardScreen());

                      }else{
                        Get.offAll(()=> const RideListScreen());
                      }
                    });

                  }
                });
              },
            )),
          ])
        ]),
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: (){
              setState(() {
                currentState = 0;
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
              child: Icon(Icons.arrow_back_rounded,size: 18),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text(
              Get.find<TripController>().parcelCancellationCauseList!.data!.ongoingRide!.length > 1 ?
              'please_select_your_cancel_reason'.tr : 'please_write_your_cancel_reason'.tr,
              style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ParcelCancellationList(isOngoing: true,expandableKey: widget.expandableKey),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ButtonWidget(buttonText: 'next'.tr,
              showBorder: true,
              transparent: true,
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              radius: Dimensions.paddingSizeSmall,
              onPressed: (){
                currentState = 2;
                setState(() {});
              })
        ]),
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
          InkWell(
            onTap: (){
              setState(() {
                currentState = 1;
                widget.expandableKey.currentState?.contract();
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
              child: Icon(Icons.arrow_back_rounded,size: 18),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: !Get.find<SplashController>().config!.parcelReturnTimeFeeStatus! ?
            Text('you_must_return_the_parcel_as_soon'.tr ,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color,fontSize: Dimensions.fontSizeDefault)) :
            RichText(text: TextSpan(
                text: 'you_must_return_the_parcel'.tr,
                style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color,fontSize: Dimensions.fontSizeDefault),
                children: [TextSpan(
                  text: ' ${Get.find<SplashController>().config?.parcelReturnTime} ',
                  style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                  TextSpan(
                    text: '${Get.find<SplashController>().config?.parcelReturnTimeType == 'day' ? 'days'.tr : 'hours'.tr} ${'admin_may_take_action'.tr} ${(Get.find<SplashController>().config?.parcelReturnFeeTimeExceed ?? 0) > 0 ? 'impost_a_fine'.tr : ''}',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                  )]
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Text('parcel_return_time'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          const CustomDatePicker(),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          const CustomTimePicker(),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          rideController.isStatusUpdating ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
          ButtonWidget(
            onPressed: (){
              if(!Get.find<SplashController>().config!.parcelReturnTimeFeeStatus!){
                rideController.tripStatusUpdate(
                    'cancelled', rideController.tripDetail!.id!,
                    "parcel_cancelled_successfully",
                    (Get.find<TripController>().parcelCancellationCauseList!.data!.ongoingRide!.length - 1) == Get.find<TripController>().parcelCancellationCurrentIndex ?
                    Get.find<TripController>().othersCancellationController.text :
                    Get.find<TripController>().parcelCancellationCauseList!.data!.ongoingRide![Get.find<TripController>().parcelCancellationCurrentIndex], [],
                    dateTime: '${Get.find<TripController>().parcelReturnDate} ${Get.find<TripController>().parcelReturnTime}'
                ).then((value) async {
                  if(value.statusCode == 200){
                    Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                    Get.offAll(()=> const DashboardScreen());
                  }});

              }else{
                DateTime pickedDateTime = DateTime.parse('${Get.find<TripController>().parcelReturnDate} ${Get.find<TripController>().parcelReturnTime}');
                Duration duration = pickedDateTime.difference(DateTime.now());
                if(duration.isNegative){
                  showCustomSnackBar('selected_time_is_in_the_past'.tr);
                }else if(
                duration.inHours > (
                    Get.find<SplashController>().config?.parcelReturnTimeType == 'day' ?
                    ((Get.find<SplashController>().config?.parcelReturnTime ?? 1) * 24) :
                    Get.find<SplashController>().config?.parcelReturnTime ?? 24)
                ){
                  showCustomSnackBar(
                      '${'selected_time_exceeds_the_allowed'.tr} ${Get.find<SplashController>().config?.parcelReturnTime} '
                          '${Get.find<SplashController>().config?.parcelReturnTimeType == 'day' ? 'days'.tr : 'hours'.tr}'
                          ' ${'limit_set_by_admin'.tr} ${Get.find<SplashController>().config?.parcelReturnTime} ${Get.find<SplashController>().config?.parcelReturnTimeType == 'day' ? 'days'.tr : 'hours'.tr}'
                  );
                }else{
                  rideController.tripStatusUpdate(
                      'cancelled', rideController.tripDetail!.id!,
                      "parcel_cancelled_successfully",
                      (Get.find<TripController>().parcelCancellationCauseList!.data!.ongoingRide!.length - 1) == Get.find<TripController>().parcelCancellationCurrentIndex ?
                      Get.find<TripController>().othersCancellationController.text :
                      Get.find<TripController>().parcelCancellationCauseList!.data!.ongoingRide![Get.find<TripController>().parcelCancellationCurrentIndex],[],
                      dateTime: '${Get.find<TripController>().parcelReturnDate} ${Get.find<TripController>().parcelReturnTime}'
                  ).then((value) async {
                    if(value.statusCode == 200){
                      Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                      Get.offAll(()=> const DashboardScreen());
                    }});
                }

              }

            },
            buttonText: 'submit'.tr,
            radius: Dimensions.radiusExtraLarge,
          )

        ]),
      );
    });
  }
}



class _OngoingTripWidget extends StatelessWidget {
  final VoidCallback callBack;
  const _OngoingTripWidget({required this.callBack});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){

      String firstRoute = '';
      String secondRoute = '';
      List<dynamic> extraRoute = [];
      if (rideController.tripDetail != null) {
        if (rideController.tripDetail!.intermediateAddresses != null && rideController.tripDetail!.intermediateAddresses != '[[, ]]') {
          extraRoute = jsonDecode(rideController.tripDetail!.intermediateAddresses!);
          if (extraRoute.isNotEmpty) {
            firstRoute = extraRoute[0];
          }
          if (extraRoute.isNotEmpty && extraRoute.length > 1) {
            secondRoute = extraRoute[1];
          }
        }
      }

      return GetBuilder<RiderMapController>(builder: (riderMapController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const RouteCalculationWidget(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('trip_details'.tr, style: textSemiBold),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: RouteWidget(
                pickupAddress: rideController.tripDetail!.pickupAddress!,
                destinationAddress: rideController.tripDetail!.destinationAddress!,
                extraOne: firstRoute,
                extraTwo: secondRoute,
                entrance: rideController.tripDetail?.entrance ?? '',
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: .25),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  PaymentItemInfoWidget(
                    icon: Images.farePrice,
                    title: 'fare_price'.tr,
                    amount: double.parse(rideController.tripDetail!.estimatedFare!),
                    isFromTripDetails: true,
                  ),

                  PaymentItemInfoWidget(
                    icon: Images.paymentTypeIcon,
                    title: 'payment'.tr, amount: 234,
                    paymentType: rideController.tripDetail!.paymentMethod!.replaceAll(RegExp('[\\W_]+'),' ').capitalize,
                  ),
                ]),
              ),
            ),

            if (rideController.tripDetail!.note != null)
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                child: Text(
                  'note'.tr,
                  style: textRegular.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),

            if (rideController.tripDetail!.note != null)
              Text(
                rideController.tripDetail!.note!,
                style: textRegular.copyWith(color: Theme.of(context).hintColor),
              ),

            if (rideController.tripDetail != null &&
                rideController.tripDetail!.type == 'parcel' &&
                rideController.tripDetail!.parcelUserInfo != null)
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall),
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    '${'who_will_pay'.tr}?',
                    style: textRegular.copyWith(color: Colors.white),
                  ),

                  Text(
                    rideController.tripDetail!.parcelInformation!.payer!.tr,
                    style: textMedium.copyWith(color: Colors.white),
                  )
                ]),
              ),

            if (rideController.tripDetail != null &&
                rideController.tripDetail!.type == AppConstants.parcel &&
                rideController.tripDetail!.parcelUserInfo != null)
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rideController.tripDetail!.parcelUserInfo!.length,
                itemBuilder: (context, index) {
                  return UserDetailsWidget(
                    name: rideController.tripDetail?.parcelUserInfo![index].name ?? '',
                    contactNumber: rideController.tripDetail?.parcelUserInfo![index].contactNumber ?? '',
                    type: rideController.tripDetail?.parcelUserInfo![index].userType ?? '',
                  );
                },
              ),

            if(rideController.tripDetail?.type == 'parcel' && (rideController.tripDetail?.isParcelDeliveryProofEnable ?? false))...[
              ParcelImageProofWidget(froPickupImage: false),
              const SizedBox(height: Dimensions.paddingSizeSmall)
            ],

            (rideController.tripDetail!.isPaused!) ?
            const SizedBox() :
            (!rideController.tripDetail!.isPaused! && rideController.tripDetail!.type != AppConstants.parcel) ?
            Column(children: [
              SliderButton(
                action: () {
                  Get.dialog(const RideCompletationDialogWidget(),barrierDismissible: false);
                },

                label: Text( "complete".tr, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                dismissThresholds: 0.5, dismissible: false, shimmer: false, width: 1170,
                height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                  child: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ?
                    Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                    color: Colors.grey,
                    size: 20.0,
                  )),
                )),
                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                baseColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SliderButton(
                action: () => callBack(),

                label: Text(
                  rideController.tripDetail?.type == AppConstants.parcel ? 'cancel_parcel'.tr : "cancel_ride".tr,
                  style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge),
                ),
                dismissThresholds: 0.5, dismissible: false, shimmer: false, width: 1170,
                height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                  child: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ?
                    Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                    color: Theme.of(context).colorScheme.error,
                    size: 20.0,
                  )),
                )),
                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
                baseColor: Theme.of(context).colorScheme.error,
              ),

            ]) :
            Column(children: [
              SliderButton(
                action: () {
                  if(
                  (rideController.tripDetail?.isParcelDeliveryProofEnable ?? false) &&
                      Get.find<OtpTimeCountController>().parcelDeliveryMultiPartImage.isEmpty
                  ){
                    showCustomSnackBar('add_delivery_proof_image'.tr);
                  }else{
                    if (rideController.tripDetail!.parcelInformation!.payer == AppConstants.sender &&
                        rideController.tripDetail!.paymentStatus == AppConstants.unPaid) {
                      rideController.getFinalFare(rideController.tripDetail!.id!).then((value) {
                        if (value.statusCode == 200) {
                          Get.to(() => const PaymentReceivedScreen(fromParcel: true));
                        }
                      });
                    } else {
                      Get.find<RideController>().remainingDistance(rideController.tripDetail!.id!, mapBound: true);
                      Get.dialog(const RideCompletationDialogWidget(),barrierDismissible: false);
                    }
                  }
                },
                label: Text('complete'.tr, style: TextStyle(color: Theme.of(context).primaryColor)),
                dismissThresholds: 0.5, dismissible: false,
                shimmer: false, width: 1170, height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                  child: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ?
                    Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                    color: Colors.grey, size: 20.0,
                  )),
                )),

                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                baseColor: Theme.of(context).primaryColor,
              ),

              ButtonWidget(
                buttonText: rideController.tripDetail?.type == AppConstants.parcel ? 'cancel_parcel'.tr : 'cancel_ride'.tr,
                textColor: Theme.of(context).colorScheme.error,
                backgroundColor: Colors.transparent,
                onPressed: () => callBack(),
              )
            ])
          ]),
        );
      });
    });
  }
}
