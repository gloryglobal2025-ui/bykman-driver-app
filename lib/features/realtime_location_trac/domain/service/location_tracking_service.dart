import 'package:ride_sharing_user_app/features/realtime_location_trac/domain/repository/location_tracking_repository_interface.dart';
import 'package:ride_sharing_user_app/features/realtime_location_trac/domain/service/location_tracking_service_interface.dart';

class LocationTrackingService extends LocationTrackingServiceInterface{
  final LocationTrackingRepositoryInterface locationTrackingRepositoryInterface;
  LocationTrackingService({required this.locationTrackingRepositoryInterface});

  @override
  Future<dynamic> getRideTrackingDetails(String trackingId) async{
    return await locationTrackingRepositoryInterface.getRideTrackingDetails(trackingId);
  }

}