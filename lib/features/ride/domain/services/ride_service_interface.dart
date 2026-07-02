import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';

abstract class RideServiceInterface {
  Future<dynamic> bidding(String tripId, String amount);
  Future<dynamic> getRideDetails(String tripId);
  Future<dynamic> uploadScreenShots(String id, XFile? file);
  Future<dynamic> getRideDetailBeforeAccept(String tripId);
  Future<dynamic> tripAcceptOrReject(String tripId, String action);
  Future<dynamic> ignoreMessage(String tripId);
  Future<dynamic> matchOtp(String tripId, String otp, List<MultipartBody> identityImage);
  Future<dynamic> startForPickup(String tripId);
  Future<dynamic> remainDistance(String id);
  Future<dynamic> tripStatusUpdate(String status, String id,String cancellationCause,String dateTime, List<MultipartBody> proofImages);
  Future<dynamic> getPendingRideRequestList(int offset, {int limit = 10});
  Future<dynamic> ongoingTripList();
  Future<dynamic> lastRideDetail();
  Future<dynamic> getFinalFare(String tripId);
  Future<dynamic> arrivalPickupPoint(String tripId);
  Future<dynamic> arrivalDestination(String tripId, String destination);
  Future<dynamic> waitingForCustomer (String tripId, String status);
  Future<dynamic> getOnGoingParcelList(int offset);
  Future<dynamic> getUnpaidParcelList(int offset);
}