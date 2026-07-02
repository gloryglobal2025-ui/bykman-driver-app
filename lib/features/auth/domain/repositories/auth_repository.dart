import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/country_code_picke.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<Response?> login({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri,
        {"phone_or_email": phone, "password": password});
  }

  @override
  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.logout, {});
  }

  @override
  Future<Response> registration({required SignUpBody signUpBody, XFile? profileImage, List<MultipartBody>? identityImage, List<MultipartDocument>? documents, Map<String, dynamic>? additionalData, List<MultipartBody>? additionalFiles}) async {
    List<MultipartBody> images = [];
    images.addAll(identityImage ?? []);
    images.addAll(additionalFiles ?? []);

    Map<String, String> bodyData = {};

    additionalData?.forEach((key, value){
      if(value is String){
        bodyData['additional_data[$key]'] = value;
      }else if(value is List<dynamic>){
        for(int i = 0 ; i< value.length ; i++){
          bodyData['additional_data[$key][$i]'] = value[i];
        }
      }
    });
    return await apiClient.postMultipartData(
        AppConstants.registration,
        signUpBody.toJson(),
        images,
        MultipartBody('profile_image', profileImage),
        documents ?? [],
        additionalData: bodyData
    );
  }

  @override
  Future<Response> registerWithOtp({
    required SignUpBody signUpBody, XFile? profileImage, List<MultipartBody>? identityImage,
    List<MultipartDocument>? documents, required bool updateFromRegistration,
    Map<String, dynamic>? additionalData, List<MultipartBody>? additionalFiles
  }) async {

    List<MultipartBody> images = [];
    images.addAll(identityImage ?? []);
    images.addAll(additionalFiles ?? []);
    Map<String, String> bodyData = {};

    additionalData?.forEach((key, value){
      if(value is String){
        bodyData['additional_data[$key]'] = value;
      }else if(value is List<dynamic>){
        for(int i = 0 ; i< value.length ; i++){
          bodyData['additional_data[$key][$i]'] = value[i];
        }
      }
    });

    return await apiClient.postMultipartData(
        updateFromRegistration ?
        AppConstants.otpLoginAfterUpdateData :
        AppConstants.registrationFromOtp,
        signUpBody.toJson(),
        images,
        MultipartBody('profile_image', profileImage),
        documents ?? [],
        additionalData: bodyData
    );
  }


  @override
  Future<Response?> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOtp,
        {"phone_or_email": phone});
  }

  @override
  Future<Response?> verifyOtp({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpVerification,
        {"phone_or_email": phone,
          "otp": otp
        });
  }

  @override
  Future<Response?> verifyFirebaseOtp({required String phone, required String otp, required String session}) async {
    return await apiClient.postData(AppConstants.otpFirebaseVerification,
        {"phone_or_email": phone,
          "code": otp,
          "session_info": session
        });
  }

  @override
  Future<Response?> resetPassword(String phoneOrEmail, String password) async {
    return await apiClient.postData(AppConstants.resetPassword,
      { "phone_or_email": phoneOrEmail,
        "password": password,},
    );
  }

  @override
  Future<Response?> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConstants.changePassword,
      { "password": oldPassword,
        "new_password": password,
      },
    );
  }



  String? deviceToken;
  @override
  Future<Response?> updateToken() async {
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
      saveDeviceToken();
    }
    if(!GetPlatform.isWeb){
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
    }
    return await apiClient.postData(AppConstants.fcmTokenUpdate, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      debugPrint('');
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }

  @override
  Future<Response?> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone});
  }



  @override
  Future<Response?> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone": phone, "otp": otp});
  }

  @override
  Future<bool?> saveUserToken(String token, String zoneId) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode), "latitude", "longitude", zoneId);
    return await sharedPreferences.setString(AppConstants.token, token);

  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    return true;
  }

  @override
  Future<void> saveUserCredential(String code ,String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
      await sharedPreferences.setString(AppConstants.loginCountryCode, code);

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveDeviceToken() async {
    try {
      await sharedPreferences.setString(AppConstants.deviceToken, deviceToken??'');
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getDeviceToken() {
    return sharedPreferences.getString(AppConstants.deviceToken) ?? "";
  }
  
  @override
  String getUserNumber() {
   return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserCountryCode() {
   // return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
    return "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  bool isNotificationActive() {
    //return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
    return true;
  }

  @override
  toggleNotificationSound(bool isNotification){
    //sharedPreferences.setBool(AppConstants.NOTIFICATION, isNotification);
  }

  @override
  Future<bool> clearUserCredential() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  bool clearSharedAddress(){
    //sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }
  
  @override
  String getZonId() {
    return sharedPreferences.getString(AppConstants.zoneId) ?? "";

  }
  
  @override
  Future<void> updateZone(String zoneId) async {
    try {
      await sharedPreferences.setString(AppConstants.zoneId, zoneId);
      apiClient.updateHeader(sharedPreferences.getString(AppConstants.token) ?? '', sharedPreferences.getString(AppConstants.languageCode), 'latitude', 'longitude', zoneId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Response?> permanentDelete() async{
    return await apiClient.postData(AppConstants.permanentDelete, {});
  }

  @override
  Future<void> saveRideCreatedTime(DateTime dateTime) async {
     await sharedPreferences.setString('DateTime', dateTime.toString());
  }

  @override
  Future<String> remainingTime() async{
    return  sharedPreferences.getString('DateTime') ?? '';
  }

  @override
  String getLoginCountryCode() {
    return sharedPreferences.getString(AppConstants.loginCountryCode) ?? "";
  }
  @override
  Future<Response?> isUserRegistered({required String phone}) async {
    return await apiClient.postData(AppConstants.checkRegisteredUserUri,
        {"phone_or_email": phone});
  }


  ///Local Database Implementation

  IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions();

  @override
  Future<bool> isBiometricEnabled() async{
    String data = await getDataFromLocalDatabase(AppConstants.biometricAuth);
    return data == 'true';
  }

  @override
  Future<dynamic> addOrUpdateOnLocalDatabase(String key, String? value) async{
    String uniqueKey = base64Encode(utf8.encode('${UniqueKey().toString()}${UniqueKey().toString()}'));
    String storeValue = base64Encode(utf8.encode('$value $uniqueKey'));
    try {
      await _storage.write(
        key: key,
        value: storeValue,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {
      debugPrint('error from : repo : $e');
    }
  }

  @override
  Future<void> setBiometricEnabled(bool isActive) async{
    if(!isActive) {
      await deleteFromLocalDatabase(AppConstants.biometricPin);
       deleteFromLocalDatabase(AppConstants.userNumber);
       deleteFromLocalDatabase(AppConstants.countryCode);
    }else{
      String countryCode = CountryCodeHelper.getCountryCode(Get.find<ProfileController>().profileInfo?.phone) ?? '';
      addOrUpdateOnLocalDatabase(AppConstants.userNumber, Get.find<ProfileController>().profileInfo?.phone?.replaceAll(countryCode, ''));
      addOrUpdateOnLocalDatabase(AppConstants.countryCode, countryCode);
    }
    addOrUpdateOnLocalDatabase(AppConstants.biometricAuth, isActive.toString());
  }

  Future<void> deleteFromLocalDatabase(String key) async {
    try {
      await _storage.delete(key: key, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    } catch (e) {
      debugPrint('error ===> $e');
    }

  }

  @override
  Future<String> getBiometricPhone(String key){
    return getDataFromLocalDatabase(key);
  }

  @override
  Future<String> getBiometricCountryCode(String key){
    return getDataFromLocalDatabase(key);
  }

  @override
  Future<String> getDataFromLocalDatabase(String key) async{
    String value = "";
    try {
      String value0 = await (_storage.read(key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions())) ?? "";
      String decodeValue =  utf8.decode(base64Url.decode(value0));
      value = decodeValue.split(' ').first;

    } catch (e) {
      debugPrint('error ===> $e');

    }
    return value;
  }

  @override
  Future<dynamic> pinVerify(String password) async{
    return await apiClient.postData(
        AppConstants.checkDriverPasswordForBiometric,
        {
          'password': password
        }
    );
  }

}
