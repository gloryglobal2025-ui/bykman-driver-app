import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button/slider_buttion_widget.dar.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/customer_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/fare_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/parcel_proof_image_view.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/parcel_refund_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/payment_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/return_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_route_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/payment_received_screen.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/sub_total_header.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';

class TripDetails extends StatefulWidget {
  final String tripId;
  const TripDetails({super.key, required this.tripId});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {


  @override
  void initState() {
    Get.find<RideController>().getRideDetails(widget.tripId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomPopScopeWidget(
        child: Scaffold(
          body: GetBuilder<RideController>(builder: (rideController) {
            String firstRoute = '';
            String secondRoute = '';
            Duration? tripDuration;
            if(rideController.tripDetail != null){
              if(rideController.tripDetail!.actualTime != null){
                tripDuration =  Duration(minutes: rideController.tripDetail!.actualTime!.ceil());
              }

              List<dynamic> extraRoute = [];
              if(rideController.tripDetail!.intermediateAddresses != null &&
                  rideController.tripDetail!.intermediateAddresses != '[[, ]]'){
                extraRoute = jsonDecode(rideController.tripDetail!.intermediateAddresses!);

                if(extraRoute.isNotEmpty){
                  firstRoute = extraRoute[0];
                }
                if(extraRoute.isNotEmpty && extraRoute.length>1){
                  secondRoute = extraRoute[1];
                }
              }
            }

            String? pickUpTime = rideController.tripDetail?.type == 'parcel' ? rideController.tripDetail?.parcelStartTime : rideController.tripDetail?.rideStartTime;
            String? dropOffTime = rideController.tripDetail?.type == 'parcel' ? rideController.tripDetail?.parcelCompleteTime : rideController.tripDetail?.rideCompleteTime;

            return rideController.tripDetail != null ?
            Column(children: [
                Flexible(child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                      AppBarWidget(title: 'trip_details'.tr),

                      SubTotalHeaderTitle(
                        title: '${'your_trip'.tr} #${rideController.tripDetail!.refId} ${'is'.tr} '
                            '${rideController.tripDetail!.currentStatus!.tr}',
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),

                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                          if(rideController.tripDetail!.actualTime != null)
                            SummeryItem(
                              title: '${tripDuration!.inHours}:${tripDuration.inMinutes % 60} hr',
                              subTitle: 'time'.tr,
                            ),

                          SummeryItem(
                            title: '${rideController.tripDetail!.actualDistance} km',
                            subTitle: 'distance'.tr,
                          ),

                        ]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Text('trip_details'.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)),
                      ),

                      if(pickUpTime != null || dropOffTime != null)
                        Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          color: Theme.of(context).hintColor.withValues(alpha:0.08),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                        child: Column(spacing: Dimensions.paddingSizeExtraSmall, children: [
                          Center(child: Text(
                            DateConverter.stringToLocalDateOnly(rideController.tripDetail!.createdAt!),
                            style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ,
                            ),
                          )),

                          IntrinsicHeight(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              if(pickUpTime != null)...[
                                FareWidget(title: 'pickup_time'.tr, value: DateConverter.stringDateTimeToTimeOnly(pickUpTime)),

                                if(dropOffTime != null)
                                VerticalDivider(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                              ],

                              if(dropOffTime != null)
                                FareWidget(title: 'drop_off_time'.tr, value: DateConverter.stringDateTimeToTimeOnly(dropOffTime)),
                            ]),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: TripRouteWidget(
                          pickupAddress: rideController.tripDetail?.pickupAddress ?? '',
                          destinationAddress: rideController.tripDetail?.destinationAddress ?? '',
                          extraOne: firstRoute,
                          extraTwo: secondRoute,
                          entrance: rideController.tripDetail?.entrance,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomerDetailsWidget(
                        rideController: rideController,
                        showReviewButton: true,
                        tripId: widget.tripId,
                        isReviewed: rideController.tripDetail!.isReviewed,
                        paymentStatus: rideController.tripDetail!.paymentStatus,
                        type: rideController.tripDetail!.type,
                      ),

                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(top: 0),
                        child: PaymentDetailsWidget(tripDetail: rideController.tripDetail),
                      ),

                      if(rideController.tripDetail!.paymentStatus == 'unpaid' && rideController.tripDetail!.paidFare != '0')
                        Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall,bottom: Dimensions.paddingSizeLarge,
                            left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault
                          ),
                          child: ButtonWidget(buttonText: 'request_for_payment'.tr, onPressed: (){
                            Get.find<RideController>().getFinalFare(rideController.tripDetail!.id!).then((value){if(value.statusCode == 200){
                              Get.to(()=> const PaymentReceivedScreen());
                            }});
                          },),
                        ),

                      if(rideController.tripDetail?.parcelRefund != null)...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Text('refund_details'.tr,style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5))),
                        ),

                        ParcelRefundDetailsWidget()
                      ],

                      if(((rideController.tripDetail?.pickupProofImages ?? []).isNotEmpty) && rideController.tripDetail?.type == 'parcel')...[
                        ParcelProofImageView(proofImages: rideController.tripDetail?.pickupProofImages ?? [], isPickupProofImage: true),

                        const SizedBox(height: Dimensions.paddingSizeSmall)
                      ],

                      if(((rideController.tripDetail?.deliveryProofImages ?? []).isNotEmpty) && rideController.tripDetail?.type == 'parcel')...[
                        ParcelProofImageView(proofImages: rideController.tripDetail?.deliveryProofImages ?? [], isPickupProofImage: false),

                        const SizedBox(height: Dimensions.paddingSizeSmall)
                      ]

                    ]),
                  )),

              if(rideController.tripDetail?.currentStatus == 'returning' && rideController.tripDetail?.type == 'parcel')...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                  child: SliderButton(
                    action: (){
                      if(rideController.tripDetail?.returnFee != null && (rideController.tripDetail?.returnFee ?? 0) > 0){
                        Get.bottomSheet(ReturnBottomSheetWidget(), isDismissible: false);
                      }else{
                        Get.dialog(const ReturnDialogWidget(),barrierDismissible: false);
                      }
                    },
                    label: Text('parcel_returned'.tr,
                      style: textSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
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
              ]

            ]) :
            const LoaderWidget();
          }),
          floatingActionButton: GetBuilder<RideController>(builder: (rideController) {
            return _showSafetyFeature(rideController) ?
            InkWell(
              onTap: (){
                Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.initialState);
                Get.bottomSheet(
                  isScrollControlled: true,
                  const SafetyAlertBottomSheetWidget(fromTripDetailsScreen: true),
                  backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                );
              },
              child: Image.asset(Images.safelyShieldIcon3,height: 40,width: 40),
            ) :
            const SizedBox();
          }),
        )
      ),
    );
  }

  bool _showSafetyFeature(RideController rideController){
    if(rideController.tripDetail?.rideCompleteTime != null){
      int time = DateTime.now().difference(DateConverter.dateTimeStringToDate(rideController.tripDetail!.rideCompleteTime!)).inSeconds;
      int activeTime = (Get.find<SplashController>().config?.afterTripCompleteSafetyFeatureSetTime ?? 0);

      return (Get.find<SplashController>().config?.afterTripCompleteSafetyFeatureActiveStatus ?? false) && rideController.tripDetail?.currentStatus ==  "completed" &&
          rideController.tripDetail?.type != "parcel" && activeTime > time && rideController.tripDetail?.driverSafetyAlert == null ? true : false;
    }else{
      return false;
    }
  }

}

class SummeryItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const SummeryItem({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check_circle,size: Dimensions.iconSizeSmall, color: Colors.green),

      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        child: Text(title, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
      ),
      Text(subTitle, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

    ]);
  }
}


