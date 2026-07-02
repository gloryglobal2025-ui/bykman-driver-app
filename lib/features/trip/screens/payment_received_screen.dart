import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/customer_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/fare_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_route_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/payment_item_info_widget.dart';

class PaymentReceivedScreen extends StatefulWidget{
  final bool fromParcel;
  const PaymentReceivedScreen({super.key,  this.fromParcel = false});

  @override
  State<PaymentReceivedScreen> createState() => _PaymentReceivedScreenState();
}

class _PaymentReceivedScreenState extends State<PaymentReceivedScreen> with WidgetsBindingObserver{
  bool canPop = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      Get.find<RideController>().getRideDetails(Get.find<RideController>().tripDetail!.id!).then((value){
        if(Get.find<RideController>().tripDetail!.paymentStatus == 'paid'){
          Get.offAll(()=> const DashboardScreen());
        }else{
          Get.find<RideController>().getFinalFare(Get.find<RideController>().tripDetail!.id!);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (willBePop, val) async {

          if(!willBePop) {
            Future.delayed(const Duration(milliseconds: 50)).then((_){
              Get.offAll(()=> const DashboardScreen());

            });
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(child: GetBuilder<RideController>(builder: (finalFareController) {
            String firstRoute = '';
            String secondRoute = '';
            List<dynamic> extraRoute = [];
            if(finalFareController.finalFare != null){
              if(finalFareController.finalFare?.intermediateAddresses != null && finalFareController.finalFare?.intermediateAddresses != '[[, ]]'){
                extraRoute = jsonDecode(finalFareController.finalFare?.intermediateAddresses ?? '');

                if(extraRoute.isNotEmpty){
                  firstRoute = extraRoute[0];
                }

                if(extraRoute.isNotEmpty && extraRoute.length>1){
                  secondRoute = extraRoute[1];
                }

              }
            }

            String? pickUpTime = finalFareController.finalFare?.type == 'parcel' ? finalFareController.finalFare?.parcelStartTime : finalFareController.finalFare?.rideStartTime;
            String? dropOffTime = finalFareController.finalFare?.type == 'parcel' ? finalFareController.finalFare?.parcelCompleteTime : finalFareController.finalFare?.rideCompleteTime;

            return (finalFareController.finalFare != null) ?
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppBarWidget(
                title: 'sub_total'.tr, showBackButton: true,
                onBackPressed: ()=> Get.offAll(()=> const DashboardScreen()),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Container(
                  width:Get.width,
                  transform: Matrix4.translationValues(0, -30, 0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: 0.2))
                  ),
                  child: Column(children: [
                    if(((finalFareController.finalFare?.discountAmount ?? 0) + (finalFareController.finalFare?.couponAmount ?? 0)) > 0)
                      Container(
                        margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
                          right: Dimensions.paddingSizeSmall,
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                        ),
                        child: IntrinsicHeight(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Text('total_trip_cost'.tr,style: textRegular),

                              Text(PriceConverter.convertPrice(
                                  context,
                                  (
                                      (finalFareController.finalFare?.discountAmount ?? 0) +
                                          (finalFareController.finalFare?.couponAmount ?? 0)
                                  ) + (
                                      finalFareController.finalFare?.paidFare ?? 0
                                  )
                              ),
                                style: textRobotoBold.copyWith(
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                  fontSize: Dimensions.fontSizeLarge,
                                ),
                              ),
                            ]),

                            VerticalDivider(thickness: 1,color: Theme.of(context).hintColor.withValues(alpha: 0.5)),

                            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Text('admin_will_pay'.tr,style: textRegular),

                              Text(
                                PriceConverter.convertPrice(
                                  context,
                                  (
                                      (finalFareController.finalFare?.discountAmount ?? 0) +
                                          (finalFareController.finalFare?.couponAmount ?? 0)
                                  ),
                                ),
                                style: textRobotoBold.copyWith(
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                  fontSize: Dimensions.fontSizeLarge,
                                ),
                              ),
                            ]),
                          ]),
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Text(
                            ((finalFareController.finalFare?.discountAmount ?? 0) + (finalFareController.finalFare?.couponAmount ?? 0)) > 0 ?
                            'customer_will_pay'.tr : 'total_trip_cost'.tr,
                            style: textBold.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Text(
                            PriceConverter.convertPrice(context, finalFareController.finalFare?.paidFare?? 0),
                            style: textRobotoBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeOverLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),

              if(!widget.fromParcel)
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    SummeryItem(title: '${finalFareController.finalFare?.actualTime} ${'minute'.tr}',
                      subTitle: 'time',
                    ),
                    SizedBox(width: Get.width * 0.2),

                    SummeryItem(title: '${finalFareController.finalFare?.actualDistance} km',
                      subTitle: 'distance',
                    ),

                  ]),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
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
                    DateConverter.stringToLocalDateOnly(finalFareController.finalFare!.createdAt!),
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ,
                    ),
                  )),

                  IntrinsicHeight(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      if(pickUpTime != null)
                        FareWidget(title: 'pickup_time'.tr, value: DateConverter.stringDateTimeToTimeOnly(pickUpTime)),

                      if(dropOffTime != null)...[
                        VerticalDivider(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),

                        FareWidget(title: 'drop_off_time'.tr, value: DateConverter.stringDateTimeToTimeOnly(dropOffTime)),
                      ]

                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: TripRouteWidget(
                  pickupAddress: '${finalFareController.finalFare?.pickupAddress}',
                  destinationAddress: '${finalFareController.finalFare?.destinationAddress}',
                  extraOne: firstRoute,
                  extraTwo: secondRoute,
                  entrance: finalFareController.finalFare?.entrance ?? '',
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              CustomerDetailsWidget(rideController: Get.find<RideController>()),

              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(top: 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2), width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('payment_details'.tr,style: textSemiBold.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        )),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                          ),
                          child: Text(
                            '${Get.find<RideController>().tripDetail?.paymentMethod}',
                            style: textRobotoMedium.copyWith(
                              color: Get.isDarkMode ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        )
                      ]),
                    ),

                    PaymentItemInfoWidget(icon: Images.farePrice,title: 'fare_price'.tr,
                      amount: finalFareController.finalFare?.distanceWiseFare?? 0,
                    ),

                    if(!widget.fromParcel && (finalFareController.finalFare?.cancellationFee ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.idleHourIcon,
                        title: 'cancellation_price'.tr,
                        amount: finalFareController.finalFare?.cancellationFee ?? 0,
                      ),

                    if(!widget.fromParcel && (finalFareController.finalFare?.idleFee ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.idleHourIcon,
                        title: 'idle_price'.tr,
                        amount: finalFareController.finalFare?.idleFee?? 0,
                      ),

                    if(!widget.fromParcel && (finalFareController.finalFare?.delayFee ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.waitingPrice,
                        title: 'delay_price'.tr,
                        amount: finalFareController.finalFare?.delayFee ?? 0,
                      ),

                    if((finalFareController.finalFare?.couponAmount ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.coupon,
                        title: 'coupon_amount'.tr,
                        amount: finalFareController.finalFare?.couponAmount?? 0,
                        discount: true,toolTipText: 'customer_applied_coupon_for_this_ride'.tr,
                        subTitle: 'later_admin_will_pay_you_this_amount',
                      ),

                    if((finalFareController.finalFare?.discountAmount ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.discountIcon,
                        title: 'discount_applied'.tr,
                        amount: finalFareController.finalFare?.discountAmount?? 0,
                        discount: true,toolTipText: 'discount_applied_for_this_ride'.tr,
                        subTitle: 'later_admin_will_pay_you_this_amount',
                      ),

                    if((finalFareController.finalFare?.vatTax ?? 0).toDouble() > 0)
                      PaymentItemInfoWidget(icon: Images.farePrice,
                        title: 'vat_tax'.tr,
                        amount: finalFareController.finalFare?.vatTax?? 0,
                      ),

                    Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('${'sub_total'.tr} (${'customer_will_pay'.tr})',style: textSemiBold.copyWith(
                        color: Theme.of(context).primaryColor,
                      )),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                        ),
                        child: Text(
                          PriceConverter.convertPrice(context, finalFareController.finalFare?.paidFare ?? 0),
                          style: textRobotoBold.copyWith(
                            color: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall)
                  ]),
                ),
              ),

            ]) :
            const SizedBox();
          })),
          bottomNavigationBar: GetBuilder<RideController>(builder: (finalFareController) {
            return GetBuilder<TripController>(builder: (tripController) {
              return Container(height: 90,
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,Dimensions.paddingSizeLarge,
                ),
                child: tripController.isLoading ?
                Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                ButtonWidget(
                  buttonText: 'payment_received'.tr,
                  onPressed: () {
                    Get.dialog(ConfirmationDialogWidget(
                      icon: Images.paymentIcon,
                      description: 'are_you_sure_you_got_cash_payment_from_customer'.tr,
                      onYesPressed: (){
                        setState(() {
                          canPop = true;
                        });
                        tripController.paymentSubmit(
                          finalFareController.finalFare!.id!, 'cash', fromParcel: widget.fromParcel,
                        );
                      },
                    ));
                  },
                ),
              );
            });
          }),
        ),
      ),
    );
  }
}

class SummeryItem extends StatelessWidget {
  final String title;
  final String subTitle;
  const SummeryItem({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(subTitle == 'time' ? Images.circularClockIcon : Images.twoPointerMapMarker, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, color: Theme.of(context).primaryColor),

      Text(title, style: textMedium),

      Text(subTitle.tr, style: textRegular.copyWith(color: Theme.of(context).hintColor)),

    ]);
  }
}


