import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/face_verification/controllers/face_verification_controller.dart';
import 'package:ride_sharing_user_app/features/home/widgets/home_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/screens/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';

class HomeScreenHelper {

  void checkMaintanenceMode(){
    int ridingCount = (Get.find<RideController>().ongoingTrip == null || Get.find<RideController>().ongoingTrip!.isEmpty) ? 0 :
    (
        Get.find<RideController>().ongoingTrip![0].currentStatus == 'ongoing' ||
            Get.find<RideController>().ongoingTrip![0].currentStatus == 'accepted' ||
            (
                Get.find<RideController>().ongoingTrip![0].currentStatus =='completed' &&
                    Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid'
            ) ||
            (
                Get.find<RideController>().ongoingTrip![0].currentStatus =='cancelled' &&
                    Get.find<RideController>().ongoingTrip![0].paymentStatus == 'unpaid' &&
                    Get.find<RideController>().ongoingTrip![0].cancelledBy == 'customer'
            ) && Get.find<RideController>().ongoingTrip![0].type != 'parcel'
    ) ? 1 : 0;
    int parcelCount = Get.find<RideController>().parcelListModel?.totalSize?? 0;

    if(ridingCount == 0 && parcelCount == 0){
      Get.find<SplashController>().saveOngoingRides(false);
      if(Get.find<SplashController>().config!.maintenanceMode != null &&
          Get.find<SplashController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
          Get.find<SplashController>().config!.maintenanceMode!.selectedMaintenanceSystem!.driverApp == 1
      ){
        Get.offAll(() => const MaintenanceScreen());
      }
    }else{
      Get.find<SplashController>().saveOngoingRides(true);
    }
  }


  void pendingListPusherImplementation(){
    for(int i =0 ;i<Get.find<RideController>().getPendingRideRequestModel!.data!.length; i++){
      PusherHelper().customerInitialTripCancel(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
      PusherHelper().anotherDriverAcceptedTrip(Get.find<RideController>().getPendingRideRequestModel!.data![i].id!,Get.find<ProfileController>().driverId);
    }
  }


  void ongoingLastRidePusherImplementation(){
    List<String> data = ["ongoing","accepted"];

    for(int i =0 ;i < Get.find<RideController>().ongoingRideList!.length; i++){
      if(data.contains(Get.find<RideController>().ongoingRideList![i].currentStatus)){
        PusherHelper().tripCancelAfterOngoing(Get.find<RideController>().ongoingRideList![i].id!);
        PusherHelper().customerInitialTripCancel(Get.find<RideController>().ongoingRideList![i].id!, Get.find<ProfileController>().driverId);
        PusherHelper().tripPaymentSuccessful(Get.find<RideController>().ongoingRideList![i].id!);
      }
    }
  }

  void ongoingParcelListPusherImplementation(){
    List<String> data = ["ongoing","accepted"];

    for(int i =0 ;i < Get.find<RideController>().parcelListModel!.data!.length; i++){
      if(data.contains(Get.find<RideController>().parcelListModel!.data![i].currentStatus)){
        PusherHelper().tripCancelAfterOngoing(Get.find<RideController>().parcelListModel!.data![i].id!);
        PusherHelper().customerInitialTripCancel(Get.find<RideController>().parcelListModel!.data![i].id!, Get.find<ProfileController>().driverId);
        PusherHelper().tripPaymentSuccessful(Get.find<RideController>().parcelListModel!.data![i].id!);
      }
    }
  }


  void checkAndShowBottomSheets(){
    if(Get.find<ProfileController>().profileInfo?.vehicle == null  &&
        Get.find<ProfileController>().isFirstTimeShowBottomSheet){

      Get.find<ProfileController>().updateFirstTimeShowBottomSheet(false);
      Future.delayed(Duration(seconds: 5)).then((_) async {

        if(Get.currentRoute == '/DashboardScreen'){
        await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: Get.context!,
        isDismissible: false,
        builder: (_) => const HomeVehicleAddBottomSheet(),
        );

        if((Get.find<SplashController>().config?.initialFaceVerificationDuringSignUp ?? false)
        && (!(Get.find<ProfileController>().profileInfo?.isVerified ?? false)) && (Get.find<SplashController>().config?.verifyDriverIdentity ?? false)){
        faceVerificationSheet();
        }
      }

      });
    }else{
      if(_checkShowBottomSheet() && Get.find<ProfileController>().isShowFaceVerificationBottomSheet && (Get.find<SplashController>().config?.verifyDriverIdentity ?? false)){
        Get.find<ProfileController>().updateFaceVerificationBottomSheet(false);
        faceVerificationSheet();
      }
    }
  }

  void faceVerificationSheet(){
    Future.delayed(Duration(seconds: 5)).then((_) async{

      if(Get.currentRoute == '/DashboardScreen'){
        final result = await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: Get.context!,
          isDismissible: false,
          builder: (_) => const HomeFaceVerificationBottomSheet(),
        );

        if(result == null || result){
          Get.find<FaceVerificationController>().skipFaceVerification();
        }
      }

    });
  }

  bool _checkShowBottomSheet(){

    ///"randomly_during_trips"---> TODO::::
    if(Get.find<SplashController>().config?.chooseVerificationWhenToTrigger == "within_a_time_period"){
      if(Get.find<ProfileController>().profileInfo?.triggerVerificationAt == null){
        return true;
      }else{
        DateTime time = DateConverter.isoStringToLocalDate(Get.find<ProfileController>().profileInfo!.triggerVerificationAt!);
        int difference = DateTime.now().difference(time).inSeconds;
        if(difference > 0){
          return true;
        }else{
          return false;
        }
      }
    }else{
      return false;
    }
  }
}