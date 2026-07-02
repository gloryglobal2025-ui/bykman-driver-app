import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/additional_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/signup_appbar_widget.dart';
import 'package:ride_sharing_user_app/helper/sign_up_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AdditionalSignUpScreen3 extends StatefulWidget {
  const AdditionalSignUpScreen3({super.key});

  @override
  State<AdditionalSignUpScreen3> createState() => _AdditionalSignUpScreen3State();
}

class _AdditionalSignUpScreen3State extends State<AdditionalSignUpScreen3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (authController) {
            return Column(children: [
              const SignUpAppbarWidget(
                title: 'signup_as_a_driver',
                progressText: '4_of_4',
                enableBackButton: true,
              ),

              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    Text(
                      'provide_additional_info'.tr,
                      style: textBold.copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(
                      'enter_the_additional_details_to_complete_the_signup'.tr,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    if (authController.additionalFields.isEmpty)
                      const SizedBox(height: Dimensions.paddingSizeLarge)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: authController.additionalFields.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          return AdditionalFieldWidget(
                            fieldModel: authController.additionalFields[index],
                            index: index,
                          );
                        },
                      ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  ],
                ),
              ),
              ),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(Dimensions.paddingSizeLarge),
                    topLeft: Radius.circular(Dimensions.paddingSizeLarge),
                  ),
                  color: Theme.of(context).cardColor,
                ),
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault).copyWith(bottom: Dimensions.paddingSizeExtraLarge),
                child: authController.isLoading
                    ? Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0))
                    : ButtonWidget(
                  buttonText: 'submit'.tr,
                  onPressed: () async {
                    SignUpHelper.submitRegistration();
                  },
                  radius: 50,
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}