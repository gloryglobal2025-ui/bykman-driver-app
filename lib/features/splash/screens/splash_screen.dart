import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/helper/login_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  const SplashScreen({super.key, this.notificationData});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  StreamSubscription<List<ConnectivityResult>>? _onConnectivityChanged;
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    if(!GetPlatform.isIOS){
      _checkConnectivity();
    }
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();

    Get.find<SplashController>().initSharedData();
    Get.find<TripController>().rideCancellationReasonList();
    Get.find<TripController>().parcelCancellationReasonList();
    Get.find<AuthController>().remainingTime();
    Get.find<WalletController>().getPaymentGetWayList();
    LoginHelper().handleIncomingLinks(widget.notificationData);

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _onConnectivityChanged?.cancel();
    _animation.removeListener(() { });
    _controller.dispose();
    super.dispose();
  }

  void _checkConnectivity(){
    bool isFirst = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);
      if((isFirst && !isConnected) || !isFirst && context.mounted) {
        ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: isConnected ? 3 : 6000),
          content: Text(
            isConnected ? 'connected'.tr : 'no_connection'.tr,
            textAlign: TextAlign.center,
          ),
        ));

        if(isConnected) {
          LoginHelper().handleIncomingLinks(widget.notificationData);
        }
      }
      isFirst = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(builder: (rideController) {
        return GetBuilder<ProfileController>(builder: (profileController) {
          return GetBuilder<LocationController>(builder: (locationController) {
            return Stack(children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white), // Changed background to white
                alignment: Alignment.bottomCenter,
                child: Column(mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end, children: [
                      Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                        Container(transform: Matrix4.translationValues(
                            0, 320 - (320 * double.tryParse(_animation.value.toString())!),
                            0),
                          child: Column(children: [
                            Opacity(opacity: _animation.value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 120 - ((120 * double.tryParse(_animation.value.toString())!)),
                                ),
                                child: Image.asset(Images.logo, width: 160), // Using dark logo for white background
                              ),
                            ),
                            const SizedBox(height: 50),

                            Image.asset(
                              Images.splashBackgroundOne, width: Get.width,
                              height: Get.height / 2,
                              fit: BoxFit.cover,
                            ),
                          ]),
                        ),

                        Container(
                          transform: Matrix4.translationValues(0, 20, 0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (70 * double.tryParse(_animation.value.toString())!),
                            ),
                            child: Image.asset(Images.splashBackgroundTwo, width: Get.size.width),
                          ),
                        )
                      ]),
                    ]),
              ),

            ]);
          });
        });
      }),
    );
  }

}
