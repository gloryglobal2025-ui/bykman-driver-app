import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/realtime_location_trac/domain/repository/location_tracking_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class LocationTrackingRepository extends LocationTrackingRepositoryInterface{
  final ApiClient apiClient;
  LocationTrackingRepository({required this.apiClient});

  @override
  Future<dynamic> getRideTrackingDetails(String trackingId) async{
    return await apiClient.getData('${AppConstants.rideTrackingUrl}$trackingId/data');
  }
}