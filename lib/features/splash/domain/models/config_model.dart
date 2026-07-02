import 'package:ride_sharing_user_app/features/auth/domain/models/additional_field_model.dart';

class ConfigModel {
  String? businessName;
  String? logo;
  bool? bidOnFare;
  String? countryCode;
  String? businessAddress;
  String? businessContactPhone;
  String? businessContactEmail;
  String? businessSupportPhone;
  String? businessSupportEmail;
  String? baseUrl;
  String? webSocketUrl;
  String? webSocketPort;
  String? webSocketKey;
  ImageBaseUrl? imageBaseUrl;
  String? currencyDecimalPoint;
  String? currencyCode;
  String? currencySymbolPosition;
  AboutUs? aboutUs;
  AboutUs? privacyPolicy;
  AboutUs? termsAndConditions;
  AboutUs? legal;
  bool? smsVerification;
  bool? emailVerification;
  String? mapApiKey;
  int? paginationLimit;
  String? facebookLogin;
  String? googleLogin;
  List<String>? timeZones;
  bool? verification;
  bool? conversionStatus;
  int? conversionRate;
  int? otpResendTime;
  bool? selfRegistration;
  String? currencySymbol;
  bool? reviewStatus;
  MaintenanceMode? maintenanceMode;
  double? completionRadius;
  bool? isDemo;
  bool? levelStatus;
  bool? referralEarningStatus;
  int? parcelReturnTime;
  String? parcelReturnTimeType;
  double? parcelReturnFeeTimeExceed;
  bool? parcelReturnTimeFeeStatus;
  double? androidAppMinimumVersion;
  double? iosAppMinimumVersion;
  String? androidAppUrl;
  String? iosAppUrl;
  bool? isFirebaseOtpVerification;
  bool? isSmsGateway;
  AboutUs? refundPolicy;
  bool? chattingSetupStatus;
  bool? driverQuestionAnswerStatus;
  String? websocketScheme;
  bool? maximumParcelRequestAcceptLimitStatus;
  int? maximumParcelRequestAcceptLimit;
  String? parcelWeightUnit;
  bool? safetyFeatureStatus;
  int? safetyFeatureMinimumTripDelayTime;
  String? safetyFeatureMinimumTripDelayTimeType;
  bool? afterTripCompleteSafetyFeatureActiveStatus;
  int? afterTripCompleteSafetyFeatureSetTime;
  String? safetyFeatureEmergencyGovtNumber;
  List<String>? fuelTypes;
  bool? otpConfirmationForTrip;
  bool? cashInHandSetupStatus;
  double? cashInHandMaxAmountHold;
  double? cashInHandMinAmountToPay;
  int? maxImageUploadSize;
  int? maxFileUploadSize;
  bool? verifyDriverIdentity;
  bool? initialFaceVerificationDuringSignUp;
  bool? triggerVerificationAtIntervals;
  String? chooseVerificationWhenToTrigger;
  int? frequencyWithinTimePeriod;
  int? tripsRequiredBeforeTriggeringVerification;
  CustomerLoginOptions? driverLoginOptions;
  bool? isRealTimeLocationShareEnable;
  bool? isParcelProofOn;
  List<AdditionalFieldModel>? additionalFieldList;

  ConfigModel({
    this.businessName,
    this.logo,
    this.bidOnFare,
    this.countryCode,
    this.businessAddress,
    this.businessContactPhone,
    this.businessContactEmail,
    this.businessSupportPhone,
    this.businessSupportEmail,
    this.baseUrl,
    this.webSocketUrl,
    this.webSocketPort,
    this.webSocketKey,
    this.imageBaseUrl,
    this.currencyDecimalPoint,
    this.currencyCode,
    this.currencySymbolPosition,
    this.aboutUs,
    this.privacyPolicy,
    this.termsAndConditions,
    this.legal,
    this.smsVerification,
    this.emailVerification,
    this.mapApiKey,
    this.paginationLimit,
    this.facebookLogin,
    this.googleLogin,
    this.timeZones,
    this.verification,
    this.conversionStatus,
    this.conversionRate,
    this.otpResendTime,
    this.selfRegistration,
    this.currencySymbol,
    this.reviewStatus,
    this.maintenanceMode,
    this.completionRadius,
    this.isDemo,
    this.levelStatus,
    this.referralEarningStatus,
    this.parcelReturnTime,
    this.parcelReturnFeeTimeExceed,
    this.parcelReturnTimeType,
    this.parcelReturnTimeFeeStatus,
    this.iosAppUrl,
    this.androidAppUrl,
    this.iosAppMinimumVersion,
    this.androidAppMinimumVersion,
    this.isFirebaseOtpVerification,
    this.isSmsGateway,
    this.refundPolicy,
    this.websocketScheme,
    this.driverQuestionAnswerStatus,
    this.chattingSetupStatus,
    this.maximumParcelRequestAcceptLimitStatus,
    this.maximumParcelRequestAcceptLimit,
    this.parcelWeightUnit,
    this.afterTripCompleteSafetyFeatureActiveStatus,
    this.afterTripCompleteSafetyFeatureSetTime,
    this.safetyFeatureEmergencyGovtNumber,
    this.safetyFeatureMinimumTripDelayTime,
    this.safetyFeatureMinimumTripDelayTimeType,
    this.safetyFeatureStatus,
    this.fuelTypes,
    this.otpConfirmationForTrip,
    this.cashInHandMaxAmountHold,
    this.cashInHandMinAmountToPay,
    this.cashInHandSetupStatus,
    this.maxFileUploadSize,
    this.maxImageUploadSize,
    this.chooseVerificationWhenToTrigger,
    this.frequencyWithinTimePeriod,
    this.initialFaceVerificationDuringSignUp,
    this.triggerVerificationAtIntervals,
    this.tripsRequiredBeforeTriggeringVerification,
    this.verifyDriverIdentity,
    this.driverLoginOptions,
    this.isRealTimeLocationShareEnable,
    this.isParcelProofOn,
    this.additionalFieldList

  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    bidOnFare = json['bid_on_fare'] != null ? (json['bid_on_fare'].toString() == '1' || json['bid_on_fare'].toString() == 'true') : null;
    if(json['country_code'] != null && json['country_code'] != ""){
      countryCode = json['country_code']??'BD';
    }else{
      countryCode = 'BD';
    }
    businessAddress = json['business_address'];
    businessContactPhone = json['business_contact_phone'];
    businessContactEmail = json['business_contact_email'];
    businessSupportPhone = json['business_support_phone'];
    businessSupportEmail = json['business_support_email'];
    baseUrl = json['base_url'];
    webSocketUrl = json['websocket_url'];
    webSocketPort = json['websocket_port'];
    webSocketKey = json['websocket_key'];
    imageBaseUrl = json['image_base_url'] != null
        ? ImageBaseUrl.fromJson(json['image_base_url'])
        : null;
    currencyDecimalPoint = json['currency_decimal_point'];
    currencyCode = json['currency_code'];
    currencySymbolPosition = json['currency_symbol_position'];
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? AboutUs.fromJson(json['privacy_policy'])
        : null;
    termsAndConditions = json['terms_and_conditions'] != null
        ? AboutUs.fromJson(json['terms_and_conditions'])
        : null;
    legal = json['legal'] != null
        ? AboutUs.fromJson(json['legal'])
        : null;
    smsVerification = json['sms_verification'] != null ? (json['sms_verification'].toString() == '1' || json['sms_verification'].toString() == 'true') : null;
    emailVerification = json['email_verification'] != null ? (json['email_verification'].toString() == '1' || json['email_verification'].toString() == 'true') : null;
    mapApiKey = json['map_api_key'];
    paginationLimit = json['pagination_limit'] != null ? int.tryParse(json['pagination_limit'].toString()) : null;
    facebookLogin = json['facebook_login'].toString();
    googleLogin = json['google_login'].toString();
    isDemo = json['is_demo'] != null ? (json['is_demo'].toString() == '1' || json['is_demo'].toString() == 'true') : null;
    levelStatus = json['level_status'] != null ? (json['level_status'].toString() == '1' || json['level_status'].toString() == 'true') : null;
    verification = '${json['verification']}'.contains('true');
    conversionStatus = json['conversion_status']??true;
    if(json['conversion_rate'] != null){
      conversionRate = json['conversion_rate'] != null ? int.tryParse(json['conversion_rate'].toString()) : null;
    }else{
      conversionRate = 0;
    }
    otpResendTime = int.tryParse(json['otp_resend_time'].toString());
    selfRegistration = json['self_registration'] != null ? (json['self_registration'].toString() == '1' || json['self_registration'].toString() == 'true') : null;
    currencySymbol = json['currency_symbol'];
    reviewStatus = json['review_status'] != null ? (json['review_status'].toString() == '1' || json['review_status'].toString() == 'true') : null;
    parcelReturnTime = json['return_time_for_driver'] != null ? int.tryParse(json['return_time_for_driver'].toString()) : null;
    parcelReturnTimeType = json['return_time_type_for_driver'];
    parcelReturnTimeFeeStatus = json['parcel_return_time_fee_status'] != null ? (json['parcel_return_time_fee_status'].toString() == '1' || json['parcel_return_time_fee_status'].toString() == 'true') : false;
    parcelReturnFeeTimeExceed = double.tryParse(json['return_fee_for_driver_time_exceed'].toString());
    maintenanceMode = json['maintenance_mode'] != null
        ? MaintenanceMode.fromJson(json['maintenance_mode'])
        : null;
    if(json['driver_completion_radius'] != null){
      try{
        completionRadius = json['driver_completion_radius'].toDouble();
      }catch(e){
        completionRadius = double.tryParse(json['driver_completion_radius'].toString());
      }
    }
    referralEarningStatus = json['referral_earning_status'] != null ? (json['referral_earning_status'].toString() == '1' || json['referral_earning_status'].toString() == 'true') : null;
    androidAppMinimumVersion = json['app_minimum_version_for_android'].toDouble();
    androidAppUrl = json['app_url_for_android'];
    iosAppMinimumVersion = json['app_minimum_version_for_ios'].toDouble();
    iosAppUrl = json['app_url_for_ios'];
    isFirebaseOtpVerification = json['firebase_otp_verification'] != null ? (json['firebase_otp_verification'].toString() == '1' || json['firebase_otp_verification'].toString() == 'true') : null;
    isSmsGateway = json['sms_gateway'] != null ? (json['sms_gateway'].toString() == '1' || json['sms_gateway'].toString() == 'true') : null;
    chattingSetupStatus = json['chatting_setup_status'] != null ? (json['chatting_setup_status'].toString() == '1' || json['chatting_setup_status'].toString() == 'true') : null;
    driverQuestionAnswerStatus = json['driver_question_answer_status'] != null ? (json['driver_question_answer_status'].toString() == '1' || json['driver_question_answer_status'].toString() == 'true') : null;
    websocketScheme = json['websocket_scheme'];
    parcelWeightUnit = json['parcel_weight_unit'];
    refundPolicy = json['refund_policy'] != null
        ? AboutUs.fromJson(json['refund_policy'])
        : null;
    maximumParcelRequestAcceptLimitStatus = json['maximum_parcel_request_accept_limit_status_for_driver'] != null ? (json['maximum_parcel_request_accept_limit_status_for_driver'].toString() == '1' || json['maximum_parcel_request_accept_limit_status_for_driver'].toString() == 'true') : null;
    maximumParcelRequestAcceptLimit = json['maximum_parcel_request_accept_limit_for_driver'] != null ? int.tryParse(json['maximum_parcel_request_accept_limit_for_driver'].toString()) : null;
    safetyFeatureStatus = json['safety_feature_status'] != null ? (json['safety_feature_status'].toString() == '1' || json['safety_feature_status'].toString() == 'true') : null;
    safetyFeatureMinimumTripDelayTime = json['safety_feature_minimum_trip_delay_time'] != null ? int.tryParse(json['safety_feature_minimum_trip_delay_time'].toString()) : null;
    safetyFeatureMinimumTripDelayTimeType = json['safety_feature_minimum_trip_delay_time_type'];
    afterTripCompleteSafetyFeatureActiveStatus = json['after_trip_completed_safety_feature_active_status'] != null ? (json['after_trip_completed_safety_feature_active_status'].toString() == '1' || json['after_trip_completed_safety_feature_active_status'].toString() == 'true') : null;
    afterTripCompleteSafetyFeatureSetTime = json['after_trip_completed_safety_feature_set_time'] != null ? int.tryParse(json['after_trip_completed_safety_feature_set_time'].toString()) : null;
    safetyFeatureEmergencyGovtNumber = json['safety_feature_emergency_govt_number'];
    fuelTypes = json['fuel_types'].cast<String>();
    fuelTypes?.insert(0,'select_fuel_type');
    otpConfirmationForTrip = json['otp_confirmation_for_trip'] != null ? (json['otp_confirmation_for_trip'].toString() == '1' || json['otp_confirmation_for_trip'].toString() == 'true') : null;
    cashInHandSetupStatus = json['cash_in_hand_setup_status'] != null ? (json['cash_in_hand_setup_status'].toString() == '1' || json['cash_in_hand_setup_status'].toString() == 'true') : null;
    cashInHandMaxAmountHold = double.tryParse('${json['cash_in_hand_max_amount_to_hold_cash']}');
    cashInHandMinAmountToPay = double.tryParse('${json['cash_in_hand_min_amount_to_pay']}');
    maxImageUploadSize = int.tryParse('${json['upload_max_image_size']}');
    maxFileUploadSize = int.tryParse('${json['upload_max_file_size']}');
    verifyDriverIdentity = json['verify_driver_identity'] != null ? (json['verify_driver_identity'].toString() == '1' || json['verify_driver_identity'].toString() == 'true') : null;
    initialFaceVerificationDuringSignUp = json['initiate_face_verification_during_sign_up'] != null ? (json['initiate_face_verification_during_sign_up'].toString() == '1' || json['initiate_face_verification_during_sign_up'].toString() == 'true') : null;
    triggerVerificationAtIntervals = json['trigger_verification_at_intervals'] != null ? (json['trigger_verification_at_intervals'].toString() == '1' || json['trigger_verification_at_intervals'].toString() == 'true') : null;
    chooseVerificationWhenToTrigger = json['choose_verification_when_to_trigger'];
    frequencyWithinTimePeriod = json['frequency_within_time_period'] != null ? int.tryParse(json['frequency_within_time_period'].toString()) : null;
    tripsRequiredBeforeTriggeringVerification = json['trips_required_before_triggering_verification'] != null ? int.tryParse(json['trips_required_before_triggering_verification'].toString()) : null;
    driverLoginOptions = json['driver_login_options'] != null ? CustomerLoginOptions.fromJson(json['driver_login_options']) : null;
    isRealTimeLocationShareEnable = json['is_real_time_location_sharing_enabled'] != null ? (json['is_real_time_location_sharing_enabled'].toString() == '1' || json['is_real_time_location_sharing_enabled'].toString() == 'true') : null;
    isParcelProofOn = json['enable_parcel_delivery_proof'] != null ? (json['enable_parcel_delivery_proof'].toString() == '1' || json['enable_parcel_delivery_proof'].toString() == 'true') : null;
    if (json['driver_additional_registration_form_fields'] != null) {
      additionalFieldList = <AdditionalFieldModel>[];
      json['driver_additional_registration_form_fields'].forEach((v) {
        additionalFieldList!.add(AdditionalFieldModel.fromJson(v));
      });
    }
  }

}



class ImageBaseUrl {
  String? profileImageCustomer;
  String? profileImageAdmin;
  String? banner;
  String? vehicleCategory;
  String? vehicleModel;
  String? vehicleBrand;
  String? profileImage;
  String? identityImage;
  String? documents;
  String? pages;
  String? conversation;
  String? additionalData;
  String? parcelPickupProof;
  String? parcelDeliveryProof;

  ImageBaseUrl(
      {this.profileImageCustomer,
        this.banner,
        this.vehicleCategory,
        this.vehicleModel,
        this.vehicleBrand,
        this.profileImage,
        this.identityImage,
        this.documents,
        this.pages,
        this.conversation,
        this.profileImageAdmin,
        this.additionalData,
        this.parcelDeliveryProof,
        this.parcelPickupProof
      });

  ImageBaseUrl.fromJson(Map<String, dynamic> json) {
    profileImageCustomer = json['profile_image_customer'];
    profileImageAdmin = json['profile_image_admin'];
    banner = json['banner'];
    vehicleCategory = json['vehicle_category'];
    vehicleModel = json['vehicle_model'];
    vehicleBrand = json['vehicle_brand'];
    profileImage = json['profile_image'];
    identityImage = json['identity_image'];
    documents = json['documents'];
    pages = json['pages'];
    conversation = json['conversation'];
    additionalData = json['additional_data'];
    parcelPickupProof = json['parcel_pickup_proof'];
    parcelDeliveryProof = json['parcel_delivery_proof'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_image_customer'] = profileImageCustomer;
    data['banner'] = banner;
    data['vehicle_category'] = vehicleCategory;
    data['vehicle_model'] = vehicleModel;
    data['vehicle_brand'] = vehicleBrand;
    data['profile_image'] = profileImage;
    data['identity_image'] = identityImage;
    data['documents'] = documents;
    data['pages'] = pages;
    data['additional_data'] = additionalData;
    return data;
  }
}
class AboutUs {
  String? image;
  String? name;
  String? shortDescription;
  String? longDescription;

  AboutUs({this.image, this.name, this.shortDescription, this.longDescription});

  AboutUs.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['long_description'] = longDescription;
    return data;
  }
}

class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode({
    this.maintenanceStatus,
    this.selectedMaintenanceSystem,
    this.maintenanceMessages,
    this.maintenanceTypeAndDuration
  });

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = json['maintenance_status'] != null ? int.tryParse(json['maintenance_status'].toString()) : null;
    selectedMaintenanceSystem = json['selected_maintenance_system'] != null
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

}

class SelectedMaintenanceSystem {
  int? userApp;
  int? driverApp;

  SelectedMaintenanceSystem(
      { this.userApp, this.driverApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    userApp = json['user_app'] != null ? int.tryParse(json['user_app'].toString()) : null;
    driverApp = json['driver_app'] != null ? int.tryParse(json['driver_app'].toString()) : null;
  }

}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'] != null ? int.tryParse(json['business_number'].toString()) : null;
    businessEmail = json['business_email'] != null ? int.tryParse(json['business_email'].toString()) : null;
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

}

class MaintenanceTypeAndDuration {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
       maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
       startDate = startDate;
    }
    if (endDate != null) {
       endDate = endDate;
    }
  }

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

}

class CustomerLoginOptions {
  bool? manualLogin;
  bool? otpLogin;
  bool? biometricLogin;

  CustomerLoginOptions({this.manualLogin, this.otpLogin, this.biometricLogin});

  CustomerLoginOptions.fromJson(Map<String, dynamic> json) {
    manualLogin = json['manual_login'] != null ? (json['manual_login'].toString() == '1' || json['manual_login'].toString() == 'true') : false;
    otpLogin = json['otp_login'] != null ? (json['otp_login'].toString() == '1' || json['otp_login'].toString() == 'true') : false;
    biometricLogin = json['biometric_login'] != null ? (json['biometric_login'].toString() == '1' || json['biometric_login'].toString() == 'true') : false;
  }

}