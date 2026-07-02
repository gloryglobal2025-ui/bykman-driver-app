import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class BiometricLoginScreen extends StatelessWidget {
  const BiometricLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('back_to_previous_page'.tr, style: textRegular.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).textTheme.bodyMedium?.color,
            onPressed: () => Get.back(),
          )

      ),
      body: GetBuilder<AuthController>(builder: (authController){
        return Stack(children: [
          Column(children: [
            const SizedBox(height: Dimensions.paddingSizeSignUp),

            Center(child: Image.asset(Images.logoWithName, height: 60)),
            SizedBox(height: Get.height * 0.1),

            Container(
              width: Get.width,
              height: Get.height * 0.45,
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)
              ),
              margin: EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                  onTap: (){
                    Get.find<AuthController>().loginWithBiometric();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.4), width: 2)
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Image.asset(Images.biometricIcon, height: 60, width: 60),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Text('click_on_the_round_icon_to_logging'.tr, textAlign: TextAlign.center),
                )
              ])),
            )
          ]),

          if(authController.isLoading)
            LoaderWidget(),
        ]);
      }),
    );
  }
}
