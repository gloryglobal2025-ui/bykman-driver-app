
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_body.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class ProfileRepositoryInterface implements RepositoryInterface{

  Future<Response?> profileOnlineOffline();
  Future<Response?> getProfileInfo();
  Future<Response?> dailyLog();
  Future<Response?> getVehicleModelList(int offset);
  Future<Response?> getVehicleBrandList(int offset);
  Future<Response?> getCategoryList(int offset);
  Future<Response?> addNewVehicle(VehicleBody vehicleBody, List<MultipartDocument> file );
  Future<Response?> updateVehicle(VehicleBody vehicleBody,String driverId);
  Future<Response?> updateProfileInfo({
    required String firstName, required String lastname, required String email,
    required String identityType, required String identityNumber,
    XFile? profile, List<MultipartBody>? identityImage,
    required List<String> services,
    required List<String> oldDocuments,
    required List<MultipartDocument> newDocuments,
    required String gender,
    Map<String, dynamic>? additionalData,
    List<MultipartBody>? additionalFiles,
    Map<String, dynamic>? oldAdditionalImages,
  });
  Future<Response> getProfileLevelInfo();
}