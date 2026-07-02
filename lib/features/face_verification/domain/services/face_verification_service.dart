import 'package:camera/camera.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/features/face_verification/domain/repositories/face_verification_repository_interface.dart';
import 'package:ride_sharing_user_app/features/face_verification/domain/services/face_verification_service_interface.dart';

class FaceVerificationService extends FaceVerificationServiceInterface{
  final FaceVerificationRepositoryInterface faceVerificationRepositoryInterface;
  FaceVerificationService({required this.faceVerificationRepositoryInterface});

  @override
  Future<Response> verifyDriverIdentity(XFile? verificationImage) {
    return faceVerificationRepositoryInterface.verifyDriverIdentity(verificationImage);
  }

  @override
  Future<Response<dynamic>> skipVerification() {
    return faceVerificationRepositoryInterface.skipVerification();
  }


}