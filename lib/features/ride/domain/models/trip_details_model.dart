import 'package:ride_sharing_user_app/features/ride/domain/enums/refund_status_enum.dart';

class TripDetailsModel {
  TripDetail? data;


  TripDetailsModel(
      {
        this.data,
        });

  TripDetailsModel.fromJson(Map<String, dynamic> json) {

    data = json['data'] != null ? TripDetail.fromJson(json['data']) : null;

  }

}

class TripDetail {
  String? id;
  String? refId;
  Customer? customer;
  Vehicle? vehicle;
  VehicleCategory? vehicleCategory;
  String? estimatedFare;
  String? orgEstFare;
  String? estimatedTime;
  double? estimatedDistance;
  String? actualFare;
  double? actualTime;
  double? actualDistance;
  String? waitingTime;
  String? idleTime;
  double? idleFee;
  double? delayFee;
  double? cancellationFee;
  double? distanceWiseFare;
  String? cancelledBy;
  double? vatTax;
  double? adminCommission;
  double? tips;
  String? additionalCharge;
  PickupCoordinates? pickupCoordinates;
  String? pickupAddress;
  PickupCoordinates? destinationCoordinates;
  String? destinationAddress;
  PickupCoordinates? customerRequestCoordinates;
  String? intermediateCoordinates;
  String? paymentMethod;
  double? couponAmount;
  double? discountAmount;
  String? note;
  String? totalFare;
  String? otp;
  int? riseRequestCount;
  String? type;
  String? createdAt;
  String? completed;
  String? entrance;
  String? intermediateAddresses;
  String? encodedPolyline;
  String? customerAvgRating;
  String? driverAvgRating;
  String? currentStatus;
  String? paidFare;
  TripStatus? tripStatus;
  ParcelInformation? parcelInformation;
  List<ParcelUserInfo>? parcelUserInfo;
  String? paymentStatus;
  List<FareBiddings>? fareBiddings;
  String? screenshot;
  bool? isPaused;
  bool? isReachedDestination;
  bool? isLoading;
  bool? isReviewed;
  double? returnFee;
  double? dueAmount;
  String? returnTime;
  ParcelRefund? parcelRefund;
  DriverSafetyAlert? driverSafetyAlert;
  DriverSafetyAlert? customerSafetyAlert;
  String? rideCompleteTime;
  String? parcelCompleteTime;
  String? rideStartTime;
  String? parcelStartTime;
  String? scheduledAt;
  String? pickupNote;
  String? driverLocationUrl;
  List<String>? pickupProofImages;
  List<String>? deliveryProofImages;
  bool? isParcelDeliveryProofEnable;

  TripDetail(
      {this.id,
        this.refId,
        this.customer,
        this.vehicle,
        this.vehicleCategory,
        this.estimatedFare,
        this.orgEstFare,
        this.estimatedTime,
        this.estimatedDistance,
        this.actualFare,
        this.actualTime,
        this.actualDistance,
        this.waitingTime,
        this.idleTime,
        this.idleFee,
        this.delayFee,
        this.cancellationFee,
        this.distanceWiseFare,
        this.cancelledBy,
        this.vatTax,
        this.tips,
        this.additionalCharge,
        this.pickupCoordinates,
        this.pickupAddress,
        this.destinationCoordinates,
        this.destinationAddress,
        this.customerRequestCoordinates,
        this.paymentMethod,
        this.couponAmount,
        this.discountAmount,
        this.note,
        this.totalFare,
        this.otp,
        this.riseRequestCount,
        this.type,
        this.createdAt,
        this.completed,
        this.entrance,
        this.intermediateAddresses,
        this.encodedPolyline,
        this.customerAvgRating,
        this.driverAvgRating,
        this.paidFare,
        this.currentStatus,
        this.tripStatus,
        this.parcelInformation,
        this.parcelUserInfo,
        this.paymentStatus,
        this.fareBiddings,
        this.screenshot,
        this.isPaused,
        this.isReachedDestination,
        this.isLoading,
        this.isReviewed,
        this.adminCommission,
        this.returnFee,
        this.dueAmount,
        this.returnTime,
        this.parcelRefund,
        this.driverSafetyAlert,
        this.customerSafetyAlert,
        this.rideCompleteTime,
        this.parcelCompleteTime,
        this.parcelStartTime,
        this.rideStartTime,
        this.scheduledAt,
        this.intermediateCoordinates,
        this.pickupNote,
        this.driverLocationUrl,
        this.pickupProofImages,
        this.deliveryProofImages,
        this.isParcelDeliveryProofEnable
      });

  TripDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refId = json['ref_id'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    vehicleCategory = json['vehicle_category'] != null ? VehicleCategory.fromJson(json['vehicle_category']) : null;
    estimatedFare = json['estimated_fare'].toString();
    orgEstFare = json['org_est_fare'].toString();
    estimatedTime = json['estimated_time'].toString();
    estimatedDistance = double.tryParse(json['estimated_distance'].toString());
    actualFare = json['actual_fare'].toString();
    actualTime = double.tryParse(json['actual_time'].toString());
    actualDistance = double.tryParse(json['actual_distance'].toString());
    waitingTime = json['waiting_time'].toString();
    idleTime = json['idle_time'].toString();
    idleFee = double.tryParse(json['idle_fee'].toString());
    delayFee = double.tryParse(json['delay_fee'].toString());
    cancellationFee = double.tryParse(json['cancellation_fee'].toString());
    distanceWiseFare = double.tryParse(json['distance_wise_fare'].toString());
    cancelledBy = json['cancelled_by'];
    vatTax = double.tryParse(json['vat_tax'].toString());
    tips = double.tryParse(json['tips'].toString());
    intermediateCoordinates = json['intermediate_coordinates'];
    additionalCharge = json['additional_charge'].toString();
    pickupCoordinates = json['pickup_coordinates'] != null
        ? PickupCoordinates.fromJson(json['pickup_coordinates'])
        : null;
    pickupAddress = json['pickup_address'];
    destinationCoordinates = json['destination_coordinates'] != null
        ? PickupCoordinates.fromJson(json['destination_coordinates'])
        : null;
    destinationAddress = json['destination_address'];
    customerRequestCoordinates = json['customer_request_coordinates'] != null
        ? PickupCoordinates.fromJson(json['customer_request_coordinates'])
        : null;
    paymentMethod = json['payment_method'];
    couponAmount = double.tryParse(json['coupon_amount'].toString());
    discountAmount = double.tryParse(json['discount_amount'].toString());
    note = json['note'];
    totalFare = json['total_fare'].toString();
    otp = json['otp'];
    riseRequestCount = json['rise_request_count'] != null ? int.tryParse(json['rise_request_count'].toString()) : null;
    type = json['type'];
    createdAt = json['created_at'];
    completed = json['completed'];
    entrance = json['entrance'];
    intermediateAddresses = json['intermediate_addresses'];
    encodedPolyline = json['encoded_polyline'];
    customerAvgRating = json['customer_avg_rating']?? '0';
    driverAvgRating = json['driver_avg_rating'];
    currentStatus = json['current_status'];
    paidFare = json['paid_fare'].toString();
    tripStatus = json['trip_status'] != null ? TripStatus.fromJson(json['trip_status']) : null;
    parcelInformation = json['parcel_information'] != null ? ParcelInformation.fromJson(json['parcel_information']) : null;
    if (json['parcel_user_info'] != null) {
      parcelUserInfo = <ParcelUserInfo>[];
      json['parcel_user_info'].forEach((v) {
        parcelUserInfo!.add(ParcelUserInfo.fromJson(v));
      });
    }
    paymentStatus = json['payment_status'];
    if (json['fare_biddings'] != null) {
      fareBiddings = <FareBiddings>[];
      json['fare_biddings'].forEach((v) {
        fareBiddings!.add(FareBiddings.fromJson(v));
      });
    }
    screenshot = json['screenshot'];
    isPaused = json['is_paused'] != null ? (json['is_paused'].toString() == '1' || json['is_paused'].toString() == 'true') : null;
    isReachedDestination = json['is_reached_destination'] != null ? (json['is_reached_destination'].toString() == '1' || json['is_reached_destination'].toString() == 'true') : false;
    isLoading = false;
    isReviewed = json['customer_review'] != null ? (json['customer_review'].toString() == '1' || json['customer_review'].toString() == 'true') : null;
    adminCommission = double.tryParse(json['admin_commission'].toString());
    returnFee = double.tryParse(json['return_fee'].toString());
    dueAmount = double.tryParse(json['due_amount'].toString());
    returnTime = json['return_time'];
    parcelRefund = json['parcel_refund'] != null ?  ParcelRefund.fromJson(json['parcel_refund']) : null;
    driverSafetyAlert = json['driver_safety_alert'] != null ? DriverSafetyAlert.fromJson(json['driver_safety_alert']) : null;
    customerSafetyAlert = json['customer_safety_alert'] != null ? DriverSafetyAlert.fromJson(json['customer_safety_alert']) : null;
    rideCompleteTime = json['ride_complete_time'];
    rideStartTime = json['ride_start_time'];
    parcelStartTime = json['parcel_start_time'];
    parcelCompleteTime = json['parcel_complete_time'];
    scheduledAt = json['scheduled_at'];
    pickupNote = json['pickup_note'];
    driverLocationUrl = json['driver_location_url'];
    pickupProofImages = json['pickup_proof_images']?.cast<String>();
    deliveryProofImages = json['delivery_proof_images']?.cast<String>();
    isParcelDeliveryProofEnable = json['is_parcel_delivery_proof_enabled'] != null ? (json['is_parcel_delivery_proof_enabled'].toString() == '1' || json['is_parcel_delivery_proof_enabled'].toString() == 'true') : null;
  }


}

class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? identificationNumber;
  String? identificationType;
  List<String>? identificationImage;
  String? profileImage;


  Customer(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.identificationNumber,
        this.identificationType,
        this.identificationImage,
        this.profileImage,
        });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    identificationNumber = json['identification_number'];
    identificationType = json['identification_type'];
    identificationImage = (json['identification_image'] ?? []).cast<String>();
    profileImage = json['profile_image'];

  }


}

class Vehicle {
  Model? model;
  String? licencePlateNumber;
  String? licenceExpireDate;
  String? vinNumber;
  String? transmission;
  String? fuelType;
  String? ownership;
  List<String>? documents;
  int? isActive;
  String? createdAt;

  Vehicle(
      {this.model,
        this.licencePlateNumber,
        this.licenceExpireDate,
        this.vinNumber,
        this.transmission,
        this.fuelType,
        this.ownership,
        this.documents,
        this.isActive,
        this.createdAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    model = json['model'] != null ? Model.fromJson(json['model']) : null;
    licencePlateNumber = json['licence_plate_number'];
    licenceExpireDate = json['licence_expire_date'];
    vinNumber = json['vin_number'];
    transmission = json['transmission'];
    fuelType = json['fuel_type'];
    ownership = json['ownership'];
    documents = (json['documents'] ?? []).cast<String>();
    isActive =  int.tryParse(json['is_active'].toString());
    createdAt = json['created_at'];
  }

}

class Model {
  String? id;
  String? name;
  int? seatCapacity;
  int? maximumWeight;
  int? hatchBagCapacity;
  String? engine;
  String? description;
  String? image;
  int? isActive;
  String? createdAt;

  Model(
      {this.id,
        this.name,
        this.seatCapacity,
        this.maximumWeight,
        this.hatchBagCapacity,
        this.engine,
        this.description,
        this.image,
        this.isActive,
        this.createdAt});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seatCapacity = json['seat_capacity'] != null ? int.tryParse(json['seat_capacity'].toString()) : null;
    maximumWeight = json['maximum_weight'] != null ? int.tryParse(json['maximum_weight'].toString()) : null;
    hatchBagCapacity = json['hatch_bag_capacity'] != null ? int.tryParse(json['hatch_bag_capacity'].toString()) : null;
    engine = json['engine'];
    description = json['description'];
    image = json['image'];
    isActive =  int.tryParse(json['is_active'].toString());
    createdAt = json['created_at'];
  }

}

class VehicleCategory {
  String? id;
  String? name;
  String? image;
  String? type;

  VehicleCategory({this.id, this.name, this.image, this.type});

  VehicleCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
  }

}

class TripStatus {
  String? pending;
  String? accepted;
  String? ongoing;
  String? completed;
  String? cancelled;


  TripStatus(
      {this.pending,
        this.accepted,
        this.ongoing,
        this.completed,
        this.cancelled,
     });

  TripStatus.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    accepted = json['accepted'];
    ongoing = json['ongoing'];
    completed = json['completed'];
    cancelled = json['cancelled'];
  }

}

class PickupCoordinates {
  String? type;
  List<double>? coordinates;

  PickupCoordinates({this.type, this.coordinates});

  PickupCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

}


class ParcelUserInfo {
  String? contactNumber;
  String? name;
  String? address;
  String? userType;

  ParcelUserInfo({this.contactNumber, this.name, this.address, this.userType});

  ParcelUserInfo.fromJson(Map<String, dynamic> json) {
    contactNumber = json['contact_number'];
    name = json['name'];
    address = json['address'];
    userType = json['user_type'];
  }

}


class ParcelDSenderReceiver {

  String? senderPersonName;
  String? senderPersonPhone;
  String? senderAddress;
  String? receiverPersonName;
  String? receiverPersonPhone;
  String? receiverAddress;


  ParcelDSenderReceiver(
      {
        this.senderPersonName,
        this.senderPersonPhone,
        this.senderAddress,
        this.receiverPersonName,
        this.receiverPersonPhone,
        this.receiverAddress,
        });

  ParcelDSenderReceiver.fromJson(Map<String, dynamic> json) {
    senderPersonName = json['sender_person_name'];
    senderPersonPhone = json['sender_person_phone'];
    senderAddress = json['sender_address'];
    receiverPersonName = json['receiver_person_name'];
    receiverPersonPhone = json['receiver_person_phone'];
    receiverAddress = json['receiver_address'];

  }


}

class ParcelInformation {
  String? parcelCategoryId;
  String? parcelCategoryName;
  String? payer;
  String? weight;

  ParcelInformation({this.parcelCategoryId, this.payer, this.weight,this.parcelCategoryName});

  ParcelInformation.fromJson(Map<String, dynamic> json) {
    parcelCategoryId = json['parcel_category_id'];
    parcelCategoryName = json['parcel_category_name'];
    payer = json['payer'];
    weight = json['weight'].toString();
  }

}


class FareBiddings {
  String? id;
  String? tripRequestsId;
  String? bidFare;


  FareBiddings(
      {this.id,
        this.tripRequestsId,
        this.bidFare,
        });

  FareBiddings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripRequestsId = json['trip_requests_id'];
    bidFare = json['bid_fare'];

  }
}



class ParcelRefund {
  List<Attachments>? attachments;
  String? readableId;
  double? parcelApproximatePrice;
  String? reason;
  RefundStatus? status;
  String? approvalNote;
  String? denyNote;
  String? note;
  double? refundAmountByAdmin;
  String? refundMethod;
  String? customerNote;

  ParcelRefund(
      {this.attachments,
        this.readableId,
        this.parcelApproximatePrice,
        this.reason,
        this.status,
        this.approvalNote,
        this.denyNote,
        this.note,
        this.refundAmountByAdmin,
        this.refundMethod,
        this.customerNote
      });

  ParcelRefund.fromJson(Map<String, dynamic> json) {
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    readableId = json['readable_id'];
    parcelApproximatePrice = double.tryParse(json['parcel_approximate_price'].toString());
    reason = json['reason'];
    status = _getStatusType(json['status']);
    approvalNote = json['approval_note'];
    denyNote = json['deny_note'];
    note = json['note'];
    refundAmountByAdmin = double.tryParse(json['refund_amount_by_admin'].toString());
    refundMethod = json['refund_method'];
    customerNote = json['customer_note'];
  }


}
RefundStatus _getStatusType(String value) {
  switch(value) {
    case 'pending': {
      return RefundStatus.pending;
    }
    case 'refunded': {
      return RefundStatus.refunded;
    }
    case 'denied': {
      return RefundStatus.denied;

    }
    default: {
      return RefundStatus.approved;
    }
  }
}

class Attachments {
  String? file;

  Attachments({this.file});

  Attachments.fromJson(Map<String, dynamic> json) {
    file = json['file'];
  }
}

class DriverSafetyAlert {
  String? id;
  String? alertLocation;
  List<String>? reason;
  String? comment;
  String? status;
  String? tripRequestId;
  String? sentBy;
  String? resolvedLocation;
  int? numberOfAlert;
  String? resolvedBy;
  String? tripStatusWhenMakeAlert;

  DriverSafetyAlert(
      {this.id,
        this.alertLocation,
        this.reason,
        this.comment,
        this.status,
        this.tripRequestId,
        this.sentBy,
        this.resolvedLocation,
        this.numberOfAlert,
        this.resolvedBy,
        this.tripStatusWhenMakeAlert});

  DriverSafetyAlert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alertLocation = json['alert_location'];
    reason = json['reason'].cast<String>();
    comment = json['comment'];
    status = json['status'];
    tripRequestId = json['trip_request_id'];
    sentBy = json['sent_by'];
    resolvedLocation = json['resolved_location'];
    numberOfAlert = json['number_of_alert'] != null ? int.tryParse(json['number_of_alert'].toString()) : null;
    resolvedBy = json['resolved_by'];
    tripStatusWhenMakeAlert = json['trip_status_when_make_alert'];
  }
}