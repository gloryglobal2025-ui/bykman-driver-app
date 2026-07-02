import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/otp_log_in_screen.dart';
import 'package:ride_sharing_user_app/features/realtime_location_trac/screens/live_location_screen.dart';
import 'package:ride_sharing_user_app/localization/language_selection_screen.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/screens/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/features/splash/screens/app_version_warning_screen.dart';
import 'package:ride_sharing_user_app/helper/firebase_helper.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'pusher_helper.dart';

class LoginHelper{

  LoginHelper();

  void handleIncomingLinks(Map<String, dynamic>? notificationData) async {

    final appLinks = AppLinks();
    final Uri? initialLink = await appLinks.getInitialLink();
    final String? deepLinkPath = initialLink?.path;

    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (!isSuccess) return;
      if (_isForceUpdate(Get.find<SplashController>().config)) {
        Get.offAll(() => const AppVersionWarningScreen());
      } else if (deepLinkPath != null && deepLinkPath.isNotEmpty) {
        Get.offAll(() => LiveLocationScreen(trackingUrl: deepLinkPath));
      } else {
        if (Get.find<LocalizationController>().haveLocalLanguageCode()) {
          checkLoginRoutes(notificationData);
        } else {
          Get.offAll(() => LanguageSelectionScreen(notificationData: notificationData));
        }
      }
    });
  }

  void checkLoginRoutes(Map<String,dynamic>? notificationData){
    FirebaseHelper().subscribeFirebaseTopic();
    if(Get.find<AuthController>().getUserToken().isNotEmpty){
      PusherHelper.initializePusher();
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if(Get.find<AuthController>().isLoggedIn()){
        if(Get.find<AuthController>().getZoneId() == ''){
          Get.offAll(()=> const AccessLocationScreen());

        }else{
          Get.find<OutOfZoneController>().getZoneList();
          Get.find<ProfileController>().getProfileInfo().then((value){
            if(value.statusCode ==200){
              Get.find<LocationController>().getCurrentLocation().then((value){
                if(notificationData != null){
                  NotificationHelper.notificationToRoute(notificationData, formSplash: true, userName: notificationData['user_name']);
                }else{
                  Get.offAll(()=> const DashboardScreen());
                }

              });
              PusherHelper().driverTripRequestSubscribe(value.body['data']['id']);
            }
          });

        }

      }else{
        if(Get.find<SplashController>().config!.maintenanceMode != null &&
            Get.find<SplashController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
            Get.find<SplashController>().config!.maintenanceMode!.selectedMaintenanceSystem!.driverApp == 1
        ){
          Get.offAll(() => const MaintenanceScreen());
        }else{
          checkLoginMedium();
        }
      }
    });
  }

  bool _isForceUpdate(ConfigModel? config) {
    double minimumVersion = GetPlatform.isAndroid
        ? config?.androidAppMinimumVersion ?? 0
        : GetPlatform.isIOS
        ? config?.iosAppMinimumVersion ?? 0
        : 0;

    return minimumVersion > 0 && minimumVersion > AppConstants.appVersion;
  }

  static void checkLoginMedium(){
    final bool isManualLogin = Get.find<SplashController>().config?.driverLoginOptions?.manualLogin ?? false;
    if(isManualLogin){
      Get.offAll(()=> const SignInScreen());
    }else{
      Get.offAll(()=> const OtpLoginScreen(fromSignIn: true));
    }
  }
}
