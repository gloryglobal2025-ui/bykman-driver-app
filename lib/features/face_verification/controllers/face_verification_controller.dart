import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/face_verification/domain/services/face_verification_service_interface.dart';
import 'package:ride_sharing_user_app/features/face_verification/screens/face_verification_result_screen.dart';
import 'package:ride_sharing_user_app/features/face_verification/screens/face_verification_screen.dart';
import 'package:ride_sharing_user_app/features/face_verification/widgets/face_verifing_dialog.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/main.dart';

class FaceVerificationController extends GetxController implements GetxService{
  final FaceVerificationServiceInterface faceVerificationServiceInterface;
  FaceVerificationController({required this.faceVerificationServiceInterface});

  bool _isBusy = false;
  set setBusy(bool value)=> _isBusy = value;
  CameraController? controller;
  int _eyeBlink = 0;
  bool _isSuccess = true;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
    ),
  );

  dynamic _imageFile;
  XFile? compressXFile;
  int get eyeBlink => _eyeBlink;
  bool get isSuccess => _isSuccess;
  dynamic get getImage => _imageFile;



  Future startLiveFeed() async {
    if (cameras.isEmpty) {
      debugPrint('No cameras available');
      return;
    }
    final camera = cameras.length > 1 ? cameras[1] : cameras[0];
    controller?.dispose();
    controller = null;
    controller = CameraController(
      camera,
      GetPlatform.isIOS ?  ResolutionPreset.medium :  ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: GetPlatform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : (GetPlatform.isIOS ? ImageFormatGroup.bgra8888 : null),
    );
    
    try {
      await controller?.initialize();
      controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });

      if(!GetPlatform.isWeb) {
        controller?.startImageStream((CameraImage cameraImage) => _inputImageFromCameraImage(image: cameraImage, camera: camera));
      }

      update();
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _inputImageFromCameraImage({
    required CameraImage image,
    required CameraDescription camera,
  }) async {
    if(GetPlatform.isWeb) return;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (GetPlatform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (GetPlatform.isAndroid) {
      var rotationCompensation = 0;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (GetPlatform.isAndroid && format != InputImageFormat.nv21) ||
        (GetPlatform.isIOS && format != InputImageFormat.bgra8888)) {
      return;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return;
    final plane = image.planes.first;

    // compose InputImage using bytes
    final inputImage =  InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    processImage(inputImage);

  }

  Future<void> processImage(InputImage inputImage) async {
    if(GetPlatform.isWeb) return;

    if (_isBusy) return;
    _isBusy = true;

    try{
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if(faces.length == 1) {
        if((faces[0].rightEyeOpenProbability ?? 1) < 0.1 && (faces[0].leftEyeOpenProbability ?? 1) < 0.1 && _eyeBlink < 3) {
          _eyeBlink++;
        }
      }
    }catch(e) {
      debugPrint('error ===> $e');
    }

    if(_eyeBlink == 3) {
      try{
        await controller?.stopImageStream().then((value)async {
          _faceDetector.close();

          final XFile file =  await controller!.takePicture();
          compressXFile = await compressFile(file);
          _imageFile =  GetPlatform.isWeb ? compressXFile : File(compressXFile!.path);
        });
      }catch(e){
        debugPrint('error is $e');
      }
      if(_imageFile != null) {
        final inputImage = GetPlatform.isWeb ? InputImage.fromFilePath(compressXFile!.path) : InputImage.fromFilePath(_imageFile!.path);
        processPicture(inputImage);
      }
    }
    update();
    _isBusy = false;
  }

  Future<void> processPicture(InputImage inputImage) async {
    if(GetPlatform.isWeb) {
       // Face detection is not supported on Web with this plugin
       // Maybe just skip or allow proceeding for Web
       return;
    }

    bool hasEyeOpen = false;
    final faces = await _faceDetector.processImage(inputImage);
    try{
      if(faces.length == 1) {
        if(faces[0].rightEyeOpenProbability != null && faces[0].leftEyeOpenProbability != null) {
          if(faces[0].rightEyeOpenProbability! > 0.2 && faces[0].leftEyeOpenProbability! > 0.2){
            hasEyeOpen = true;
          }
        }
      }
    }catch(e){
      debugPrint('error ---> $e');
    }

    if(hasEyeOpen || GetPlatform.isIOS) {
      Future.delayed(const Duration(seconds: 1)).then((value) async {
        await _faceDetector.close();
        Get.dialog(
            const FaceVerifyingDialog(),
            barrierDismissible: false
        );

        Response response = await faceVerificationServiceInterface.verifyDriverIdentity(compressXFile);
        stopLiveFeed();
        Get.find<ProfileController>().getProfileInfo();
        Get.offAll(()=> FaceVerificationResultScreen(
          isSuccess: response.statusCode == 200,
          message: response.body['message'],
        ));

      });


    }else{
      _isSuccess = false;
      update();
    }

  }

  Future<XFile> compressFile(XFile file) async {
    if(GetPlatform.isWeb) return file;
    final filePath = file.path;

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path, _generateCompressedFilePath(filePath),
      quality: 50,
    );

    return result ?? file;
  }

  String _generateCompressedFilePath(String filePath) {
    final int lastDotIndex = filePath.lastIndexOf(RegExp(r'\.jp'));
    if(lastDotIndex == -1) return "${filePath}_compressed";
    final String baseFileName = filePath.substring(0, lastDotIndex);
    final String fileExtension = filePath.substring(lastDotIndex);

    return "${baseFileName}_compressed$fileExtension";
  }


  void removeImage(){
    compressXFile = null;
    _imageFile = null;
    update();
  }

  Future stopLiveFeed() async {
    _isBusy = false;
    try{
      try{
        if(controller != null && controller!.value.isStreamingImages) {
           await controller?.stopImageStream();
        }
      }catch(e) {
        debugPrint('error ---> $e');
      }
      await controller?.dispose();
      controller = null;
      valueInitialize();
    }catch(e){
      debugPrint('error is : $e');

    }
  }

  void valueInitialize() {
    _eyeBlink = 0;
    _isSuccess = true;
  }

  Future<void> requestCameraPermission() async {
    if(GetPlatform.isWeb) {
       Get.to(()=> FaceVerificationScreen());
       return;
    }
    var serviceStatus = await Permission.camera.status;

    if(serviceStatus.isGranted && GetPlatform.isAndroid){
      Get.to(()=> FaceVerificationScreen());
    }else{
      if(GetPlatform.isIOS){
        Get.to(()=> FaceVerificationScreen());
      }else{
        final status = await Permission.camera.request();
        if (status == PermissionStatus.granted) {
          Get.to(()=> FaceVerificationScreen());
        } else if (status == PermissionStatus.denied) {
          showDeniedDialog();
        } else if (status == PermissionStatus.permanentlyDenied) {
          showPermanentlyDeniedDialog();
        }
      }

    }
  }

  void showDeniedDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'camera_permission'.tr,
      middleText: 'you_must_allow_permission_for_further_use'.tr,
      confirm: TextButton(onPressed: () async{
        Permission.camera.request().then((value) async{
          var status = await Permission.camera.status;
          if (status.isDenied) {
            Get.back();
            Permission.camera.request();

          }
          else if(status.isGranted){
          }
          else if(status.isPermanentlyDenied){
            return showPermanentlyDeniedDialog();
          }
        });


      }, child: Text('allow'.tr)),
    );

  }

  void showPermanentlyDeniedDialog() {
    Get.defaultDialog(
        barrierDismissible: false,
        title: 'camera_permission'.tr,
        middleText: 'you_must_allow_permission_for_further_use'.tr,
        confirm: TextButton(onPressed: () async {
          final serviceStatus = await Permission.camera.status;
          if(serviceStatus.isGranted){
            Get.off(()=> FaceVerificationScreen());
          }
          else{
            await openAppSettings().then((value)async{
              if(serviceStatus.isGranted){
                Get.to(()=> FaceVerificationScreen());
              }
              else{
                Get.back();
                showPermanentlyDeniedDialog();
              }
            });
          }

        }, child: Text('open_setting'.tr))
    );
  }

  void skipFaceVerification({bool fromVarificationScreen = false}) async{
    Response response = await faceVerificationServiceInterface.skipVerification();
    if(response.statusCode == 200){
      if(fromVarificationScreen){
        showCustomSnackBar('your_verification_failed_try_it_later'.tr);
      }
    }else{
      ApiChecker.checkApi(response);
    }
  }

}