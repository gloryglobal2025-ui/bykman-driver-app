import 'package:universal_io/io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseHelper {

  void subscribeFirebaseTopic() async{
    if (kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_on');
      await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_off');
      await FirebaseMessaging.instance.subscribeToTopic('drivers_send_notification');
      return;
    }

    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_on');
        await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_off');
        await FirebaseMessaging.instance.subscribeToTopic('drivers_send_notification');
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_on');
          await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_off');
          await FirebaseMessaging.instance.subscribeToTopic('drivers_send_notification');
        }
      }
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_on');
      await FirebaseMessaging.instance.subscribeToTopic('driver_maintenance_mode_off');
      await FirebaseMessaging.instance.subscribeToTopic('drivers_send_notification');
    }
  }
}
