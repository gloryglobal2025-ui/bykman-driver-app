class RideTrackDetailsModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  Data? data;
  List<String>? errors;

  RideTrackDetailsModel({
    this.responseCode,
    this.message,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors
  });

  RideTrackDetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'] != null ? int.tryParse(json['total_size'].toString()) : null;
    limit = json['limit'] != null ? int.tryParse(json['limit'].toString()) : null;
    offset = json['offset'] != null ? int.tryParse(json['offset'].toString()) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'].cast<String>();
  }

}

class Data {
  String? id;
  String? tripRequestId;
  String? driverId;
  String? customerId;
  String? encodedPolyline;
  String? driverProfileImage;
  String? customerProfileImage;
  String? driverName;
  String? customerName;
  String? vehicleImage;
  String? vehicleModelName;
  String? licencePlateNumber;
  String? latitude;
  String? longitude;
  String? vehicleType;

  Data({
    this.id,
    this.tripRequestId,
    this.driverId,
    this.customerId,
    this.encodedPolyline,
    this.driverName,
    this.vehicleImage,
    this.vehicleModelName,
    this.licencePlateNumber,
    this.latitude,
    this.longitude,
    this.vehicleType,
    this.customerName,
    this.customerProfileImage,
    this.driverProfileImage
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripRequestId = json['trip_request_id'];
    driverId = json['driver_id'];
    customerId = json['customer_id'];
    encodedPolyline = json['encoded_polyline'];
    customerName = json['customer_name'];
    driverName = json['driver_name'];
    vehicleImage = json['vehicle_image'];
    vehicleModelName = json['vehicle_model_name'];
    licencePlateNumber = json['licence_plate_number'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    vehicleType = json['vehicle_type'];
    driverProfileImage = json['driver_profile_image'];
    customerProfileImage = json['customer_profile_image'];
  }
}
