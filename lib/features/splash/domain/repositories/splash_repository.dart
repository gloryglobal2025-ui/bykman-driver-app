import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepository implements SplashRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  const SplashRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> getConfigData() {
    return apiClient.getData(AppConstants.configUri);
  }

  @override
  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode);
    }

    return Future.value(true);
  }

  @override
  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
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
  bool haveOngoingRides(){
    return sharedPreferences.getBool(AppConstants.haveOngoingRides) ?? false;
  }

  @override
  void saveOngoingRides(bool value) {
     sharedPreferences.setBool(AppConstants.haveOngoingRides, value);
  }

  @override
  void addLastReFoundData(Map<String,dynamic>? data) => sharedPreferences.setString(AppConstants.lastRefund, jsonEncode(data));

  @override
  Map<String, dynamic>? getLastRefundData() {
    final lastRefundString = sharedPreferences.getString(AppConstants.lastRefund);

    if (lastRefundString == null) {
      return null;
    }

    return jsonDecode(lastRefundString);
  }


}