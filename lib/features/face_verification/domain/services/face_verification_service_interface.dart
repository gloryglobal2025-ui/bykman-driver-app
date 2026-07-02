import 'package:camera/camera.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class FaceVerificationServiceInterface {
  Future<Response> verifyDriverIdentity(XFile? verificationImage);
  Future<Response> skipVerification();
}