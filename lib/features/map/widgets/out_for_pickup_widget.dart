import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button/slider_buttion_widget.dar.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/home/screens/ride_list_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/map/widgets/parcel_image_proof_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/ride_cancelation_list.dart';
import 'package:ride_sharing_user_app/features/map/widgets/otp_verification_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/rider_details_widget.dart';
import 'package:ride_sharing_user_app/features/map/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OutForPickupWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const OutForPickupWidget({super.key, required this.expandableKey});

  @override
  State<OutForPickupWidget> createState() => _OutForPickupWidgetState();
}

class _OutForPickupWidgetState extends State<OutForPickupWidget> {
  int currentState = 0;
  late final KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription<bool> keyboardSubscription;


  @override
  void initState() {
    Get.find<RiderMapController>().setSheetHeight(250, false);
    _keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = _keyboardVisibilityController.onChange.listen((isVisible) {
      if (!isVisible) {
        widget.expandableKey.currentState?.contract(duration: 500);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(builder: (riderController){
      return GetBuilder<RideController>(builder: (rideController){
        return currentState == 0 ?
        rideController.tripDetail != null ?
        _AcceptedTripWidget(
          callBack: (){
            currentState = 1;
            widget.expandableKey.currentState?.expand();
            setState(() {});
            },
          expandBottomSheet: (){
            widget.expandableKey.currentState?.expand();
          },
        ) :
        const SizedBox() :
        rideController.tripDetail?.type != 'parcel' ?
        Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text('your_pickup_time_is_continuing'.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            RideCancellationList(isOngoing: false,expandableKey: widget.expandableKey,),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            Row(children: [
              Expanded(child: ButtonWidget(buttonText: 'no_continue_trip'.tr,
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

              Expanded(child: ButtonWidget(buttonText: 'submit'.tr,
                showBorder: true,
                transparent: true,
                textColor: Get.isDarkMode ? Colors.white : Colors.black,
                borderColor: Theme.of(context).hintColor,
                radius: Dimensions.paddingSizeSmall,
                onPressed: (){
                  rideController.remainingDistance(rideController.tripDetail!.id!, mapBound: true);
                  rideController.tripStatusUpdate(
                    'cancelled', rideController.tripDetail!.id!,
                    "trip_cancelled_successfully",
                    (Get.find<TripController>().rideCancellationCauseList!.data!.acceptedRide!.length - 1) == Get.find<TripController>().rideCancellationCurrentIndex ?
                    Get.find<TripController>().othersCancellationController.text :
                    Get.find<TripController>().rideCancellationCauseList!.data!.acceptedRide![Get.find<TripController>().rideCancellationCurrentIndex], []
                  ).then((value) {
                    if(value.statusCode == 200){
                      rideController.ongoingTripList().then((value){
                        if((rideController.ongoingTrip ?? []).isEmpty){
                          Get.find<OtpTimeCountController>().initialCounter();
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
                Get.find<TripController>().parcelCancellationCauseList!.data!.acceptedRide!.length > 1 ?
                'please_select_your_cancel_reason'.tr : 'please_write_your_cancel_reason'.tr,
                style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ParcelCancellationList(isOngoing: false,expandableKey: widget.expandableKey),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            ButtonWidget(
              buttonText: 'submit'.tr,
              showBorder: true,
              transparent: true,
              backgroundColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              radius: Dimensions.paddingSizeSmall,
              onPressed: (){
                rideController.tripStatusUpdate(
                  'cancelled', rideController.tripDetail!.id!,
                  "parcel_cancelled_successfully",
                  (Get.find<TripController>().parcelCancellationCauseList!.data!.acceptedRide!.length - 1) == Get.find<TripController>().parcelCancellationCurrentIndex ?
                  Get.find<TripController>().othersCancellationController.text :
                  Get.find<TripController>().parcelCancellationCauseList!.data!.acceptedRide![Get.find<TripController>().parcelCancellationCurrentIndex], []
                ).then((value) {
                  if(value.statusCode == 200){
                    rideController.ongoingTripList().then((value){
                      if((rideController.ongoingTrip ?? []).isEmpty){
                        Get.find<OtpTimeCountController>().initialCounter();
                        Get.find<RiderMapController>().setRideCurrentState(RideState.initial);
                        Get.offAll(()=> const DashboardScreen());

                      }else{
                        Get.offAll(()=> const RideListScreen());
                      }
                    });
                  }
                });
                },
            )
          ]),
        ) ;
      });
    });
  }
}

class _AcceptedTripWidget extends StatefulWidget {
  final VoidCallback callBack;
  final VoidCallback expandBottomSheet;

  const _AcceptedTripWidget({required this.callBack, required this.expandBottomSheet});

  @override
  State<_AcceptedTripWidget> createState() => _AcceptedTripWidgetState();
}

class _AcceptedTripWidgetState extends State<_AcceptedTripWidget> {
  String totalDistance = '0', estDistance = '0', removeComma= '0';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderMapController>(builder: (riderController){
      return GetBuilder<RideController>(builder: (rideController){

        if(rideController.tripDetail!.estimatedDistance.toString().contains("km")){
          removeComma = rideController.tripDetail!.estimatedDistance.toString().replaceAll("km", '');
          totalDistance = removeComma.replaceAll(",", '');

        }
        estDistance = double.parse(totalDistance).toStringAsFixed(2);

        return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Column(children: [
            if(Get.find<SplashController>().config?.otpConfirmationForTrip ?? false)
              (riderController.currentRideState == RideState.outForPickup && riderController.isInside ) ?
              OtpVerificationWidget(
                onTap: (){
                  widget.expandBottomSheet();
                },
              ) :
              Column(children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text('your_pickup_time_is_continuing'.tr,
                  style: textRegular.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(
                  'Please_reach_the_pickup_point'.tr,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.25)),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  child: const OtpVerificationWidget(fromOtp: false),
                )
              ]),

            (riderController.currentRideState == RideState.outForPickup && riderController.isInside ) ?
            const SizedBox() :
            const SizedBox(height: Dimensions.paddingSizeDefault),

            RiderDetailsWidget(rideController: rideController),
            
            if(rideController.matchedMode != null)...[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Text('trip_details'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if(rideController.tripDetail?.type == 'scheduled_request')
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('pickup_date_time'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                    Text(DateConverter.tripDetailsShowFormat(rideController.tripDetail?.scheduledAt ?? ''), style: textSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                    ))
                  ]),
                )
              else
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                      Image.asset(Images.circularClockIcon, height: 12, width: 12),

                      Text('${rideController.tripDetail?.estimatedTime} ${'min_away'.tr}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                    ]),

                    Text('${'distance'.tr}: ${rideController.matchedMode?.distanceText}', style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeSmall,
                    ))
                  ]),
                ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if(rideController.tripDetail?.type == 'scheduled_request' && (DateConverter.findTimeDifference(rideController.tripDetail?.scheduledAt ?? '') > 0))...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text(
                    '${'your_pickup_time_start'.tr} ${DateConverter.getMinutesToDayHourMinutes(DateConverter.findTimeDifference(rideController.tripDetail?.scheduledAt ?? ''))} ${'from_now'.tr}',
                    style: textRegular.copyWith(color: Theme.of(context).colorScheme.surfaceContainer),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ],
              const SizedBox(height: Dimensions.paddingSizeSmall)
            ],

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: RouteWidget(
                pickupAddress: rideController.tripDetail?.pickupAddress ?? '',
                destinationAddress: rideController.tripDetail?.destinationAddress ?? '',
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if(rideController.tripDetail!.type != 'parcel')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [
                    SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(
                      Images.distanceCalculated,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text("total_distance".tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7))),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(totalDistance.contains('km') ?
                  rideController.tripDetail!.estimatedDistance.toString() :
                  '${double.parse(rideController.tripDetail!.estimatedDistance.toString()).toStringAsFixed(2)} km',
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
                  ),

                ]),
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            _FareDetailsWidget(rideController: rideController),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            if (rideController.tripDetail?.pickupNote != null && (rideController.tripDetail?.pickupNote ?? '').isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      '${'pickup_note'.tr}: ',
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),

                    Expanded(child: Text(
                      rideController.tripDetail?.pickupNote ?? '',
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    )),
                  ]),
                ),
              ),

              SizedBox(height: Dimensions.paddingSizeSmall),
            ],

            if(rideController.tripDetail?.type == 'parcel' && (rideController.tripDetail?.isParcelDeliveryProofEnable ?? false))...[
              Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(top: 0),
                child: ParcelImageProofWidget(froPickupImage: true),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall)
            ],


            if(!(Get.find<SplashController>().config?.otpConfirmationForTrip ?? false))...[
              rideController.isPinVerificationLoading ?
              SizedBox(width: 30,height: 30,child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) :
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: SliderButton(
                  action: () {
                    if(
                    rideController.tripDetail?.type == 'parcel' &&
                        (rideController.tripDetail?.isParcelDeliveryProofEnable ?? false) &&
                        Get.find<OtpTimeCountController>().parcelReceivingImage.isEmpty
                    ){
                      showCustomSnackBar('add_pickup_proof_image'.tr);
                    }else{
                      rideController.matchOtp(
                          rideController.tripDetail!.id!, '',
                          Get.find<OtpTimeCountController>().parcelReceivingMultiPartImage
                      );
                    }
                  },
                  label: Text('start_trip'.tr,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                  ),
                  dismissThresholds: 0.5, dismissible: false, shimmer: false,width: 1170,
                  height: 40, buttonSize: 40, radius: 20,
                  icon: Center(child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Theme.of(context).cardColor,
                    ),
                    child: Center(child: Icon(
                      Get.find<LocalizationController>().isLtr ?
                      Icons.arrow_forward_ios_rounded :
                      Icons.keyboard_arrow_left,
                      color: Colors.grey, size: Dimensions.paddingSizeLarge,
                    )),
                  )),
                  isLtr: Get.find<LocalizationController>().isLtr,
                  boxShadow: const BoxShadow(blurRadius: 0),
                  buttonColor: Colors.transparent,
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  baseColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall)
            ],

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: SliderButton(
                action: () => widget.callBack(),
                label: Text(rideController.tripDetail!.type != "parcel" ? 'cancel_ride'.tr : 'cancel_parcel'.tr,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge),
                ),
                dismissThresholds: 0.5, dismissible: false, shimmer: false,width: 1170,
                height: 40, buttonSize: 40, radius: 20,
                icon: Center(child: Container(width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).cardColor,
                  ),
                  child: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ?
                    Icons.arrow_forward_ios_rounded :
                    Icons.keyboard_arrow_left,
                    color: Theme.of(context).colorScheme.error, size: Dimensions.paddingSizeLarge,
                  )),
                )),
                isLtr: Get.find<LocalizationController>().isLtr,
                boxShadow: const BoxShadow(blurRadius: 0),
                buttonColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
                baseColor: Theme.of(context).colorScheme.error,
              ),
            )
          ]),
        );
      });
    });
  }
}


class _FareDetailsWidget extends StatefulWidget {
  final RideController rideController;
  const _FareDetailsWidget({required this.rideController});

  @override
  State<_FareDetailsWidget> createState() => _FareDetailsWidgetState();
}

class _FareDetailsWidgetState extends State<_FareDetailsWidget> {
  JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(Get.find<RideController>().tripDetail?.type == 'parcel'){
        tooltipController.showTooltip();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
      ),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Image.asset(Images.farePrice,
              height: Dimensions.paddingSizeDefault,
              width: Dimensions.paddingSizeDefault,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text('fare_price'.tr,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            if(widget.rideController.tripDetail?.type == 'parcel')
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(
                  (widget.rideController.tripDetail?.parcelInformation?.payer ?? 'sender') == 'sender' ?
                  'sender_will_pay'.tr : 'receiver_will_pay'.tr,
                  style: textRegular.copyWith(fontSize: 12),
                ),
              ),
          ]),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color:  Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            child: Text(
              PriceConverter.convertPrice(
                context,double.parse(widget.rideController.tripDetail!.estimatedFare!),
              ),
              style: textRobotoBold.copyWith(
                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Row(children: [
            Image.asset(Images.paymentTypeIcon,
              height: Dimensions.paddingSizeDefault,
              width: Dimensions.paddingSizeDefault,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text('payment_method'.tr,
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),

            if(widget.rideController.tripDetail?.type == 'parcel')
              JustTheTooltip(
                backgroundColor: Get.isDarkMode ?
                Theme.of(context).primaryColor :
                Theme.of(context).textTheme.bodyMedium!.color,
                controller: tooltipController,
                preferredDirection: AxisDirection.up,
                tailLength: 10,
                isModal: true,
                tailBaseWidth: 20,
                content: Container(width: 200,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Text(
                    _paymentToolTipText(
                      widget.rideController.tripDetail?.parcelInformation?.payer ?? 'sender',
                      widget.rideController.tripDetail?.paymentMethod ?? 'cash',
                    ),
                    style: textRegular.copyWith(
                        color: Colors.white, fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: Icon(Icons.info,color: Theme.of(context).primaryColor,size: 16),
                ),
              )
          ])),

          Text(
            widget.rideController.tripDetail?.paymentMethod?.replaceAll(
                RegExp('[\\W_]+'),' ').capitalize ?? 'cash'.tr,
            style: TextStyle(color: Theme.of(context).primaryColor),
          )
        ]),
      ]),
    );
  }
}


String _paymentToolTipText(String whoPay,String paymentMethod){
  if(whoPay == 'sender'){
    return paymentMethod == 'cash' ?
    'before_start_trip_collect_payment'.tr :
    'customer_paid_the_amount_digitally'.tr;
  }else{
    return 'the_receiver_pay_the_bill'.tr;
  }
}
