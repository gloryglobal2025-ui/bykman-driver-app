import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SignUpAppbarWidget extends StatelessWidget {
  final String title;
  final String progressText;
  final bool enableBackButton;

  const SignUpAppbarWidget({super.key,required this.title, required this.progressText, this.enableBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      height: 80,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 5), // changes position of shadow
            )
          ]
      ),
      child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          enableBackButton ?
          InkWell(
            onTap: ()=> Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Icon(Icons.arrow_back_ios),
            ),
          ): const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Text(title.tr,style: textBold),
          ]),

        CircularPercentIndicator(
            radius: Get.height * 0.032,
          percent: progressText == '1_of_4' ? 0.25 : progressText == '2_of_4' ? 0.50 : progressText == '3_of_4' ? 0.75 : progressText == '1_of_3' ? 0.33 : progressText == '2_of_3' ? 0.66 : 1,
            circularStrokeCap: CircularStrokeCap.round,
            center: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
              Text(progressText.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

              Text(
                (Get.find<SplashController>().config?.additionalFieldList ?? []).isNotEmpty ? '4' : '3',
                style: textSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
              )
            ]),
            progressColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).hintColor.withValues(alpha: .18),
        )
      ]),
    );
  }
}
