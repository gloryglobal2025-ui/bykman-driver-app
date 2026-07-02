import 'package:camera/camera.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/face_verification/domain/repositories/face_verification_repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class FaceVerificationRepository extends FaceVerificationRepositoryInterface{
  final ApiClient apiClient;
  FaceVerificationRepository({required this.apiClient});

  @override
  Future<Response> verifyDriverIdentity(XFile? verificationImage) async{
    return await apiClient.postMultipartData(
        AppConstants.faceVeryUri,
        {},
        [],
        MultipartBody('image', verificationImage),
        []
    );
  }

  @override
  Future<Response<dynamic>> skipVerification() async{
    return await apiClient.getData(AppConstants.skipFaceVerify);
  }


}