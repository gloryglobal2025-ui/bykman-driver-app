import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';

class OtpTimeCountController extends GetxController implements GetxService {
  int min = 0, sec = 0;
  double remainingPercent = 0;
  int currentState = 0;
  int duration = 120;
  Timer? _animationTimer;
  int totalTimeSecond = 363;

  List<XFile> parcelReceivingImage = [];
  List<MultipartBody> parcelReceivingMultiPartImage = [];

  List<XFile> parcelDeliveryImage = [];
  List<MultipartBody> parcelDeliveryMultiPartImage = [];

  void startCountingState() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalTimeSecond--;
      if (totalTimeSecond > 0) {
        if (duration >= 0) {
          if (duration >= 60) {
            min = ((duration % 3600) / 60).floor();
          }else{
            min = 0;
          }
          sec = (duration % 60);
        } else {
          currentState = 1;
          duration = 240;
        }
        duration--;
        update();
      } else {
        _animationTimer?.cancel();
        min = 0;
        sec = 0;
        update();
      }
    });
  }

  void initialCounter(){
   min = 0; sec = 0;
   remainingPercent = 0;
   currentState = 0;
   duration = 120;
   _animationTimer?.cancel();
   totalTimeSecond = 363;
   update();
  }

  void resumeCountingTime(int oldTime){
    totalTimeSecond = 363 - oldTime;
    if(totalTimeSecond > 360){
      totalTimeSecond = 0;
      currentState = 1;
      update();
    }else if(totalTimeSecond<= 360 && totalTimeSecond >240){
      currentState = 0;
      duration = totalTimeSecond - 240;
    }else{
      currentState = 1;
      duration = totalTimeSecond;
    }
    startCountingState();
  }

  void pickProofImage(ImageSource source, bool froPickupImage)async {
    Get.back();
    XFile?  selectedImage;
    selectedImage = await FileValidationHelper.validateAndPickImage(source: source);
    if(selectedImage != null){
      if(froPickupImage){
        parcelReceivingImage.add(selectedImage);
        parcelReceivingMultiPartImage.add(MultipartBody('pickup_proof_images[]', selectedImage));
      }else{
        parcelDeliveryImage.add(selectedImage);
        parcelDeliveryMultiPartImage.add(MultipartBody('delivery_proof_images[]', selectedImage));
      }
    }

    update();
  }

  void removeImage(int index, bool froPickupImage){
    if(froPickupImage){
      parcelReceivingImage.removeAt(index);
      parcelReceivingMultiPartImage.removeAt(index);
    }else{
      parcelDeliveryImage.removeAt(index);
      parcelDeliveryMultiPartImage.removeAt(index);
    }
    update();
  }

  void clearAllImages(){
    parcelReceivingImage = [];
    parcelReceivingMultiPartImage = [];
    parcelDeliveryImage = [];
    parcelDeliveryMultiPartImage = [];
  }

}
