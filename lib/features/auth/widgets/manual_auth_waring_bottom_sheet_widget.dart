import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/screens/forgot_password_screen.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';


class ManualAuthWaringBottomSheetWidget extends StatelessWidget {
  final String phoneNumber;
  final VerificationForm from;
  const ManualAuthWaringBottomSheetWidget({super.key, required this.phoneNumber, required this.from});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeDefault), topLeft: Radius.circular(Dimensions.paddingSizeDefault))
      ),
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text('account_already_exist'.tr),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        from == VerificationForm.resetPassword ?
        Text('this_phone_number_already_used_with_otp'.tr, textAlign: TextAlign.center) :
        Text('warning_for_merge_account'.tr, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        from == VerificationForm.resetPassword ?
        Text('are_you_want_to_update_password'.tr) :
        Text('are_you_want_to_merge_account'.tr, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          Expanded(
            child: ButtonWidget(
                backgroundColor: Theme.of(context).hintColor,
                onPressed: (){
                  Get.back();
                  if(from == VerificationForm.verifyUser){
                    showCustomSnackBar('please_change_the_phone_number'.tr);
                  }
                },
                buttonText: 'no'.tr
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(
            child: ButtonWidget(
                onPressed: ()=> Get.off(()=> ForgotPasswordScreen(phoneNumber: phoneNumber, from: from)),
                buttonText: 'yes'.tr
            ),
          )
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall)
      ]),
    );
  }
}
