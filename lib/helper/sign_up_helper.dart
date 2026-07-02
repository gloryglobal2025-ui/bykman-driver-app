import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class SignUpHelper {
  static void submitRegistration() async{
    final authController = Get.find<AuthController>();
    final String? invalidField = authController.validateAdditionalFields();
    if (invalidField != null) {
      showCustomSnackBar('${titleFormatedName(invalidField)} ${'is_required'.tr}');
      return;
    }
    List<String> services = [];
    if(authController.isRideShare){
      services.add('ride_request');
    }
    if(authController.isParcelShare){
      services.add('parcel');
    }
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    SignUpBody signUpBody = SignUpBody(
        email: authController.emailController.text.trim(),
        address: authController.addressController.text.trim(),
        identityNumber: authController.identityNumberController.text.trim(),
        identificationType: authController.identityType,
        fName: authController.fNameController.text,
        lName: authController.lNameController.text,
        phone: authController.countryDialCode+authController.phoneController.text,
        password: authController.passwordController.text,
        confirmPassword: authController.confirmPasswordController.text,
        services: services,
        referralCode: authController.referralCodeController.text.trim(),
        fcmToken: deviceToken,
        gender: authController.selectedGender
    );
    authController.register(authController.countryDialCode, signUpBody);
  }
}