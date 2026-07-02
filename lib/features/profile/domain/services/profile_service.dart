
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_body.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';

class ProfileService implements ProfileServiceInterface{

  final ProfileRepositoryInterface profileRepositoryInterface;
  ProfileService({required this.profileRepositoryInterface});

  @override
  Future addNewVehicle(VehicleBody vehicleBody, List<MultipartDocument> file) {
    return profileRepositoryInterface.addNewVehicle(vehicleBody, file);
  }

  @override
  Future updateVehicle(VehicleBody vehicleBody, String driverId) {
    return profileRepositoryInterface.updateVehicle(vehicleBody, driverId);
  }

  @override
  Future dailyLog() {
    return profileRepositoryInterface.dailyLog();
  }

  @override
  Future getCategoryList(int offset) {
    return profileRepositoryInterface.getCategoryList(offset);
  }

  @override
  Future getProfileInfo() {
    return profileRepositoryInterface.getProfileInfo();
  }

  @override
  Future getVehicleBrandList(int offset) {
    return profileRepositoryInterface.getVehicleBrandList(offset);
  }

  @override
  Future getVehicleModelList(int offset) {
    return profileRepositoryInterface.getVehicleModelList(offset);
  }

  @override
  Future profileOnlineOffline() {
   return profileRepositoryInterface.profileOnlineOffline();
  }

  @override
  Future updateProfileInfo({
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
  }) {
    return profileRepositoryInterface.updateProfileInfo(
        firstName: firstName, lastname: lastname, email: email, identityType: identityType, identityNumber: identityNumber,
        profile: profile, identityImage: identityImage, services: services, oldDocuments: oldDocuments, newDocuments: newDocuments,
      gender: gender, additionalFiles: additionalFiles, additionalData: additionalData, oldAdditionalImages: oldAdditionalImages,
    );
  }

  @override
  Future getProfileLevelInfo() {
    return profileRepositoryInterface.getProfileLevelInfo();
  }



}