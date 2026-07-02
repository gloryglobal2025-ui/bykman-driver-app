import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/screens/splash_screen.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/di_container.dart' as di;
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/localization/messages.dart';
import 'package:ride_sharing_user_app/theme/dark_theme.dart';
import 'package:ride_sharing_user_app/theme/light_theme.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'features/map/controllers/map_controller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBW1ZVdezka5bzG2v9D-MU-GcfrylbKP90",
        appId: "1:183358730638:web:b9d890a267b7bc59dc34df",
        messagingSenderId: "183358730638",
        projectId: "bykman",
      ),
    );
  } else if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyChPYtnc5VN_LmLGX89BpDCszpHJNyd08o",
        appId: "1:183358730638:web:b9d890a267b7bc59dc34df",
        messagingSenderId: "183358730638",
        projectId: "bykman",
        authDomain: "bykman.firebaseapp.com",
        databaseURL: "https://bykman-default-rtdb.firebaseio.com",
        storageBucket: "bykman.firebasestorage.app",
        measurementId: "G-6Y4JMHP6X1",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Error fetching available cameras: $e');
    cameras = [];
  }

  Map<String, Map<String, String>> languages = await di.init();

  final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(MyApp(languages: languages, notificationData: remoteMessage?.data));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final Map<String, dynamic>? notificationData;
  const MyApp({super.key, required this.languages, this.notificationData});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Get.isDarkMode
            ? const Color(0xFF053B35)
            : Colors.white, // Changed to white for light mode
        statusBarIconBrightness:
            Get.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            Get.isDarkMode ? Brightness.light : Brightness.dark));
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
    }

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (configController) {
          return (GetPlatform.isWeb && configController.config == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? darkTheme : lightTheme,
                  locale: localizeController.locale,
                  home: SplashScreen(notificationData: notificationData),
                  translations: Messages(languages: languages),
                  fallbackLocale: Locale(AppConstants.languages[0].languageCode,
                      AppConstants.languages[0].countryCode),
                  defaultTransition: Transition.fade,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(0.95)),
                      child: SafeArea(
                        top: false,
                        child: GetBuilder<RideController>(
                            builder: (rideController) {
                          return Stack(
                            children: [
                              child!,
                              if (rideController.notSplashRoute) ...[
                                if (!(Get.find<SplashController>()
                                                .config!
                                                .maintenanceMode !=
                                            null &&
                                        Get.find<SplashController>()
                                                .config!
                                                .maintenanceMode!
                                                .maintenanceStatus ==
                                            1 &&
                                        Get.find<SplashController>()
                                                .config!
                                                .maintenanceMode!
                                                .selectedMaintenanceSystem!
                                                .driverApp ==
                                            1) ||
                                    Get.find<SplashController>()
                                        .haveOngoingRides()) ...[
                                  Positioned(
                                    top: Get.height * 0.3,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        Response res =
                                            await rideController.getRideDetails(
                                                rideController.rideId ?? '1',
                                                fromHomeScreen: true);
                                        if (res.statusCode == 403 ||
                                            rideController.tripDetail
                                                    ?.currentStatus ==
                                                'returning' ||
                                            rideController.tripDetail
                                                    ?.currentStatus ==
                                                'returned') {
                                          Get.find<RiderMapController>()
                                              .setRideCurrentState(
                                                  RideState.initial);
                                        }
                                        Get.to(() => const MapScreen());
                                      },
                                      onHorizontalDragEnd:
                                          (DragEndDetails details) {
                                        _onHorizontalDrag(details);
                                        Get.to(() => const MapScreen());
                                      },
                                      child: Stack(children: [
                                        SizedBox(
                                            width:
                                                Dimensions.iconSizeExtraLarge,
                                            child: Image.asset(
                                                Images.homeToMapIcon,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 5,
                                            right: 5,
                                            child: SizedBox(
                                                width: 15,
                                                child: Image.asset(Images.map,
                                                    color: Get.isDarkMode
                                                        ? Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .color
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .shadow)))
                                      ]),
                                    ),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                      ),
                    );
                  });
        });
      });
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0) return;

    if (details.primaryVelocity!.compareTo(0) == -1) {
      debugPrint('dragged from left');
    } else {
      debugPrint('dragged from right');
    }
  }
}
