import 'dart:convert';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';

  static String getSplashRoute({Map<String, dynamic>? notificationData}) {
    notificationData?.remove('body');
    String userName = (notificationData?['user_name'] ?? '').replaceAll(
        '&', 'a');
    notificationData?.remove('user_name');

    return '$splash?notification=${jsonEncode(
        notificationData)}&userName=$userName';
  }
}

