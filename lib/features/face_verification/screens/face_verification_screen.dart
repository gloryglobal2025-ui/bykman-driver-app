import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/features/face_verification/widgets/camera_instruction_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({super.key});

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {

  @override
  void dispose() {
    Get.find<FaceVerificationController>().stopLiveFeed();
    super.dispose();
  }

  @override
  void initState() {
    Get.find<FaceVerificationController>().valueInitialize();
    Get.find<FaceVerificationController>().startLiveFeed();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: AppBarWidget(title: 'verify_your_identity'.tr, regularAppbar: true),
        body: Column(children: [
          Flexible(flex: 2, child: GetBuilder<FaceVerificationController>(
            builder: (faceVerificationController) {
              if (faceVerificationController.controller == null ||
                  faceVerificationController.controller?.value.isInitialized == false) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              final controller = faceVerificationController.controller!;

              return Center(child: Stack(fit: StackFit.expand, children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      child: OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: size.width,
                            height: size.width * controller.value.aspectRatio,
                            child: CameraPreview(controller),
                          ),
                        ),
                      ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(Get.height * 0.05),
                  child: Image.asset(Images.cameraCircleIcon),
                ),

              ]));
            },
          )),

          Flexible(flex: 2, child: CameraInstructionWidget()),
        ]),
      ),
    );
  }
}