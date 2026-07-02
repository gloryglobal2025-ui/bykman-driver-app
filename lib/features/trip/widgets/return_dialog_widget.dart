import 'dart:async';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/help_and_support/screens/help_and_support_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReturnDialogWidget extends StatefulWidget {
  const ReturnDialogWidget({super.key});

  @override
  State<ReturnDialogWidget> createState() => _ReturnDialogWidgetState();
}

class _ReturnDialogWidgetState extends State<ReturnDialogWidget> {
  Timer? _timer;
  int _seconds = 0;
  String otp = '';

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController){
      return Dialog(
          surfaceTintColor: Theme.of(context).cardColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
          child: Container(
            padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(onTap: ()=> Get.back(), child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Image.asset(
                      Images.crossIcon,
                      height: Dimensions.paddingSizeSmall,
                      width: Dimensions.paddingSizeSmall,
                      color: Theme.of(context).cardColor,
                    ),
                  )),
                ),

                Text('enter_cancellation_otp'.tr,style: textBold),

                Text('collect_the_otp'.tr),

                Padding(padding:  EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge,horizontal: Get.width * 0.18),
                  child: Center(
                    child: MaterialPinField(
                      length: 4,
                      theme: MaterialPinTheme(
                        cellSize: const Size(40, 40),
                        borderWidth: 1,
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                        cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
                        cursorHeight: 20,
                        animationDuration: const Duration(milliseconds: 300),
                        borderColor: Theme.of(context).hintColor.withValues(alpha:0.2),
                        filledBorderColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                        fillColor: Theme.of(context).cardColor,
                        filledFillColor: Theme.of(context).cardColor,
                        focusedFillColor: Theme.of(context).cardColor,
                        focusedBorderColor: Theme.of(context).hintColor.withValues(alpha:0.2),
                      ),
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        otp = value;
                      },
                    ),
                  ),
                ),

                tripController.isLoading ?
                Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
                ButtonWidget(
                  width: Get.width * 0.5,
                  buttonText: 'submit'.tr,
                  onPressed: (){
                     if(otp.trim().isEmpty){
                       showCustomSnackBar('otp_required'.tr);
                     }else{
                       tripController.parcelReturnSubmitOtp(Get.find<RideController>().tripDetail?.id ?? '', otp).then((value){
                         if(value.statusCode == 200){
                           Get.back();
                           showCustomSnackBar('parcel_returned_successfully'.tr);
                         }
                       });
                     }
                  },

                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('didnot_receive_code'.tr,style: textBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                    onTap: (){
                      if(_seconds == 0){
                        _startTimer();
                        tripController.resendReturnedOtp(Get.find<RideController>().tripDetail?.id ?? '');
                      }
                    },
                    child: RichText (
                      text: TextSpan(text: '${'resend_it'.tr} ', style: textBold.copyWith(color: Theme.of(context).colorScheme.surfaceContainer),
                        children: <TextSpan>[
                          TextSpan(text: _seconds > 0 ?'${'after'.tr} (${_seconds}s)' : '', style: textBold.copyWith()),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                RichText (
                  text: TextSpan(text: '${'or_contact_with'.tr} ', style: textMedium.copyWith(color: Theme.of(context).colorScheme.secondaryFixedDim),
                    children: <TextSpan>[
                      TextSpan(
                        text: Get.find<SplashController>().config?.businessName ?? '',
                        style: textBold.copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap =(){
                          Get.to(()=> HelpAndSupportScreen());
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ],
            ),
          )
      );
    });
  }
}


class ReturnBottomSheetWidget extends StatelessWidget {
  const ReturnBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeLarge), topRight: Radius.circular(Dimensions.paddingSizeLarge)),
        color: Theme.of(context).cardColor
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(),

          Container(width: Dimensions.paddingSizeLarge, height: Dimensions.paddingSizeExtraSmall, color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),

          InkWell(
            onTap: (){
              Get.back();
              Get.dialog(const ReturnDialogWidget(),barrierDismissible: false);
            },
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Image.asset(
                Images.crossIcon,
                height: Dimensions.paddingSizeSmall,
                width: Dimensions.paddingSizeSmall,
                color: Theme.of(context).cardColor,
              ),
            ),
          )
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Image.asset(Images.returnGifAnimation, height: 120, width: 200),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text('collect_money_from_customer'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisSize: MainAxisSize.min, children: [
          Text('${'return_fee'.tr} : ', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

          Text(
            PriceConverter.convertPrice(context, Get.find<RideController>().tripDetail?.returnFee ?? 0),
            style: textRobotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
          )
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        ButtonWidget(
            onPressed: (){
              Get.back();
              Get.dialog(const ReturnDialogWidget(),barrierDismissible: false);
            },
            buttonText: 'okay'.tr,
          radius: 50,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault)

      ]),
    );
  }
}
