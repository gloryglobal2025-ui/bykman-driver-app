
import 'package:ride_sharing_user_app/features/profile/domain/models/categoty_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/profile_additional_data.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_brand_model.dart';

class ProfileModel {
  String? responseCode;
  ProfileInfo? data;


  ProfileModel(
      {this.responseCode,
        this.data,
        });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    data = json['data'] != null ? ProfileInfo.fromJson(json['data']) : null;

  }

}

class ProfileInfo {
  String? id;
  String? firstName;
  String? lastName;
  Level? level;
  Vehicle? vehicle;
  String? email;
  String? phone;
  String? identificationNumber;
  String? identificationType;
  String? profileImage;
  String? phoneVerifiedAt;
  String? userType;
  Details? details;
  Wallet? wallet;
  int? loyaltyPoint;
  TimeTrack? timeTrack;
  double? avgRatting;
  int? reviewCount;
  List<String>? identificationImage;
  bool? isOldIdentificationImage;
  double? tripIncome;
  double? totalTips;
  double? totalEarning;
  double? totalCommission;
  double? paidAmount;
  double? levelUpRewardAmount;
  List<String>? documents;
  bool? isVerified;
  bool? isSuspended;
  String? suspendReason;
  String? triggerVerificationAt;
  bool? needVerification;
  List<ProfileAdditionalData>? additionalData;
  String? loggedInVia;
  String? gender;

  ProfileInfo(
      {this.id,
        this.firstName,
        this.lastName,
        this.level,
        this.vehicle,
        this.email,
        this.phone,
        this.identificationNumber,
        this.identificationType,
        this.profileImage,
        this.phoneVerifiedAt,
        this.userType,
        this.details,
        this.wallet,
        this.loyaltyPoint,
        this.timeTrack,
        this.avgRatting,
        this.identificationImage,
        this.isOldIdentificationImage,
        this.tripIncome,
        this.totalTips,
        this.totalEarning,
        this.totalCommission,
        this.paidAmount,
        this.levelUpRewardAmount,
        this.documents,
        this.reviewCount,
        this.isVerified,
        this.isSuspended,
        this.suspendReason,
        this.triggerVerificationAt,
        this.needVerification,
        this.loggedInVia,
        this.additionalData,
        this.gender,

      });

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    email = json['email'];
    phone = json['phone'];
    identificationNumber = json['identification_number'];
    identificationType = json['identification_type'];
    profileImage = json['profile_image']??'';
    phoneVerifiedAt = json['phone_verified_at'];
    userType = json['user_type'];
    reviewCount = json['total_review'] != null ? int.tryParse(json['total_review'].toString()) : null;
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    loyaltyPoint = json['loyalty_points'] != null ? int.tryParse(json['loyalty_points'].toString()) : null;
    timeTrack = json['time_track'] != null
        ? TimeTrack.fromJson(json['time_track'])
        : null;
    avgRatting = json['rating'].toDouble();
    tripIncome = json['trip_income'].toDouble();
    totalTips = json['total_tips'].toDouble();
    totalEarning = json['total_earning'].toDouble();
    totalCommission = json['total_commission'].toDouble();
    paidAmount = json['paid_amount'].toDouble();
    levelUpRewardAmount = json['level_up_reward_amount'].toDouble();
    if(json['old_identification_image'] == null && json['identification_image'] == null){
      identificationImage = null;
    }else if(json['old_identification_image'] == null){
      identificationImage =  json['identification_image'].cast<String>();
      isOldIdentificationImage = false;
    }else {
      identificationImage =  json['old_identification_image'].cast<String>();
      isOldIdentificationImage = true;
    }
    documents = json['other_documents']?.cast<String>();
    isVerified = json['is_verified'] != null ? (json['is_verified'].toString() == '1' || json['is_verified'].toString() == 'true') : null;
    isSuspended = json['is_suspended'] != null ? (json['is_suspended'].toString() == '1' || json['is_suspended'].toString() == 'true') : null;
    suspendReason = json['suspend_reason'];
    triggerVerificationAt = json['trigger_verification_at'];
    needVerification = json['need_verification'] != null ? (json['need_verification'].toString() == '1' || json['need_verification'].toString() == 'true') : null;
    loggedInVia = json['logged_in_via'];
    if (json['additional_data'] != null) {
      additionalData = <ProfileAdditionalData>[];
      json['additional_data'].forEach((v) {
        additionalData!.add(ProfileAdditionalData.fromJson(v));
      });
    }
    gender = json['gender'];
  }

}

class Level {
  String? id;
  int? sequence;
  String? name;
  String? rewardType;
  String? rewardAmount;
  String? image;
  int? minRide;
  int? minRidePoint;
  int? minEarn;
  int? minEarnPoint;
  int? maxCancel;
  int? maxCancelPoint;
  int? reviewReceived;
  int? reviewReceivedPoint;
  String? userType;
  int? isActive;

  Level(
      {this.id,
        this.sequence,
        this.name,
        this.rewardType,
        this.rewardAmount,
        this.image,
        this.minRide,
        this.minRidePoint,
        this.minEarn,
        this.minEarnPoint,
        this.maxCancel,
        this.maxCancelPoint,
        this.reviewReceived,
        this.reviewReceivedPoint,
        this.userType,
        this.isActive});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'] != null ? int.tryParse(json['sequence'].toString()) : null;
    name = json['name'];
    rewardType = json['reward_type'];
    rewardAmount = json['reward_amount'];
    image = json['image'];
    minRide = json['min_ride'] != null ? int.tryParse(json['min_ride'].toString()) : null;
    minRidePoint = json['min_ride_point'] != null ? int.tryParse(json['min_ride_point'].toString()) : null;
    minEarn = json['min_earn'] != null ? int.tryParse(json['min_earn'].toString()) : null;
    minEarnPoint = json['min_earn_point'] != null ? int.tryParse(json['min_earn_point'].toString()) : null;
    maxCancel = json['max_cancel'] != null ? int.tryParse(json['max_cancel'].toString()) : null;
    maxCancelPoint = json['max_cancel_point'] != null ? int.tryParse(json['max_cancel_point'].toString()) : null;
    reviewReceived = json['review_received'] != null ? int.tryParse(json['review_received'].toString()) : null;
    reviewReceivedPoint = json['review_received_point'] != null ? int.tryParse(json['review_received_point'].toString()) : null;
    userType = json['user_type'];
    isActive = json['is_active'] != null ? int.tryParse(json['is_active'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sequence'] = sequence;
    data['name'] = name;
    data['reward_type'] = rewardType;
    data['reward_amount'] = rewardAmount;
    data['image'] = image;
    data['min_ride'] = minRide;
    data['min_ride_point'] = minRidePoint;
    data['min_earn'] = minEarn;
    data['min_earn_point'] = minEarnPoint;
    data['max_cancel'] = maxCancel;
    data['max_cancel_point'] = maxCancelPoint;
    data['review_received'] = reviewReceived;
    data['review_received_point'] = reviewReceivedPoint;
    data['user_type'] = userType;
    data['is_active'] = isActive;
    return data;
  }
}

class Vehicle {
  String? id;
  Brand? brand;
  VehicleModels? model;
  Category? category;
  String? licencePlateNumber;
  String? licenceExpireDate;
  String? vinNumber;
  String? transmission;
  String? fuelType;
  String? ownership;
  List<String>? documents;
  int? isActive;
  String? createdAt;
  String? vehicleRequestStatus;
  String? denyNote;
  double? parcelWeightCapacity;

  Vehicle(
      {
        this.id,
        this.brand,
        this.model,
        this.category,
        this.licencePlateNumber,
        this.licenceExpireDate,
        this.vinNumber,
        this.transmission,
        this.fuelType,
        this.ownership,
        this.documents,
        this.isActive,
        this.createdAt,
        this.parcelWeightCapacity,
        this.denyNote,
        this.vehicleRequestStatus
      });

  Vehicle.fromJson(Map<String, dynamic> json) {
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    model = json['model'] != null ? VehicleModels.fromJson(json['model']) : null;
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    licencePlateNumber = json['licence_plate_number'];
    licenceExpireDate = json['licence_expire_date'];
    vinNumber = json['vin_number'];
    id = json['id'];
    transmission = json['transmission'];
    fuelType = json['fuel_type'];
    ownership = json['ownership'];
    documents = json['documents'].cast<String>();
    isActive =  int.tryParse(json['is_active'].toString());
    createdAt = json['created_at'];
    vehicleRequestStatus = json['vehicle_request_status'];
    denyNote = json['deny_note'];
    parcelWeightCapacity = json['parcel_weight_capacity'] == null ? null :
    double.tryParse('${json['parcel_weight_capacity']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (model != null) {
      data['model'] = model!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['licence_plate_number'] = licencePlateNumber;
    data['licence_expire_date'] = licenceExpireDate;
    data['vin_number'] = vinNumber;
    data['transmission'] = transmission;
    data['fuel_type'] = fuelType;
    data['ownership'] = ownership;
    data['documents'] = documents;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    return data;
  }
}


class Details {
  int? id;
  String? userId;
  String? isOnline;
  String? availabilityStatus;
  String? updatedAt;
  String? online;
  String? offline;
  double? onlineTime;
  double? onDrivingTime;
  double? idleTime;
  List<String>? services;

  Details(
      {this.id,
        this.userId,
        this.isOnline,
        this.availabilityStatus,
        this.updatedAt,
        this.online,
        this.offline,
        this.onlineTime,
        this.onDrivingTime,
        this.idleTime,
        this.services
      });

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    userId = json['user_id'];
    isOnline = json['is_online'];
    availabilityStatus = json['availability_status'];
    updatedAt = json['updated_at'];
    online = json['online'];
    offline = json['offline'];
    onlineTime = double.tryParse(json['online_time'].toString());
    onDrivingTime =  double.tryParse(json['on_driving_time'].toString());
    idleTime = double.tryParse(json['idle_time'].toString());
    if(json['service'] != null){
      services = [];
      for(String value in json['service']){
        services!.add(value);
      }
    }
  }

}

class Wallet {
  String? id;
  double? payableBalance;
  double? receivableBalance;
  double? receivedBalance;
  double? pendingBalance;
  double? walletBalance;
  double? totalWithdrawn;
  double? referralEarn;

  Wallet(
      {this.id,
        this.payableBalance,
        this.receivableBalance,
        this.receivedBalance,
        this.pendingBalance,
        this.walletBalance,
        this.totalWithdrawn,
        this.referralEarn
      });

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payableBalance = double.tryParse(json['payable_balance'].toString());
    receivableBalance = double.tryParse(json['receivable_balance'].toString());
    receivedBalance = double.tryParse(json['received_balance'].toString());
    pendingBalance = double.tryParse(json['pending_balance'].toString());
    walletBalance = double.tryParse(json['wallet_balance'].toString());
    totalWithdrawn = double.tryParse(json['total_withdrawn'].toString());
    referralEarn = double.tryParse(json['referral_earn'].toString());
  }

}

class TimeTrack {
  int? id;
  String? date;
  int? totalOnline;
  int? totalOffline;
  int? totalIdle;
  int? totalDriving;

  TimeTrack(
      {this.id,
        this.date,
        this.totalOnline,
        this.totalOffline,
        this.totalIdle,
        this.totalDriving});

  TimeTrack.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    date = json['date'];
    totalOnline = json['total_online'] != null ? int.tryParse(json['total_online'].toString()) : null;
    totalOffline = json['total_offline'] != null ? int.tryParse(json['total_offline'].toString()) : null;
    totalIdle = json['total_idle'] != null ? int.tryParse(json['total_idle'].toString()) : null;
    totalDriving = json['total_driving'] != null ? int.tryParse(json['total_driving'].toString()) : null;
  }

}
