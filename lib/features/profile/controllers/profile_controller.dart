import 'dart:async';
import 'package:universal_io/io.dart';
import 'package:camera/camera.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/additional_field_model.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/level_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/country_code_picke.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/categoty_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/profile_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/reward_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_brand_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/vehicle_body.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/config.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';

class ProfileController extends GetxController implements GetxService{
  final ProfileServiceInterface profileServiceInterface;

  ProfileController({required this.profileServiceInterface});


  bool isLoading = false;
  List<RewardModel> rewardList = [];
  List<String> termList = [];

  List<String> profileType = ['my_profile','my_level','my_vehicle',];

  int _profileTypeIndex = 0;
  int get profileTypeIndex => _profileTypeIndex;
  List<int> profileTypeIndexList = [];
  List<MultipartDocument> documents = [];
  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;
  List<FilePickerResult> listOfDocuments = [];
  PlatformFile? objFile;
  List<String>? oldDocuments;
  bool isFirstTimeShowBottomSheet = true;
  bool isCashInHandWarningShow = false;
  bool isCashInHandHoldAccount = false;
  bool isShowFaceVerificationBottomSheet = true;

  TimeTrack? timeTrack;

  ///For Additional Data update
  List<AdditionalFieldModel> _additionalFields = [];
  List<AdditionalFieldModel> get additionalFields => _additionalFields;

  final Map<String, TextEditingController> _additionalFieldControllers = {};
  Map<String, TextEditingController> get additionalFieldControllers => _additionalFieldControllers;

  final Map<String, FocusNode> _additionalFieldFocusNodes = {};
  Map<String, FocusNode> get additionalFieldFocusNodes => _additionalFieldFocusNodes;
  final Map<String, List<dynamic>> _additionalFieldFiles = {};
  Map<String, List<dynamic>> get additionalFieldFiles => _additionalFieldFiles;
  final Map<String, dynamic> _additionalFieldCheckValues = {};
  Map<String, dynamic> get additionalFieldCheckValues => _additionalFieldCheckValues;
  final Map<String, String> _additionalFieldPhoneCountryCodes = {};
  Map<String, String> get additionalFieldPhoneCountryCodes => _additionalFieldPhoneCountryCodes;

  final Map<String, dynamic> additionalData = {};
  List<MultipartBody> additionalFiles = [];
  Map<String, dynamic> oldAdditionalImages = {};



  void updateFirstTimeShowBottomSheet(bool status){
    isFirstTimeShowBottomSheet = status;
  }

  void updateFaceVerificationBottomSheet(bool status){
    isShowFaceVerificationBottomSheet = status;
  }

  void setProfileTypeIndex(int index,{bool isUpdate = false}){
    _profileTypeIndex = index;
    if(index == 0){
      profileTypeIndexList = [];
      profileTypeIndexList.add(0);
    }else{
      profileTypeIndexList.remove(index);
      profileTypeIndexList.add(index);
    }
    if(isUpdate){
      update();
    }
  }

  void moveToPreviousProfileType(){
    _profileTypeIndex = profileTypeIndexList[profileTypeIndexList.length - 2];
    profileTypeIndexList.removeLast();
    update();
  }


  final zoomDrawerController = ZoomDrawerController();
  bool toggle = false;

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    toggle = ! toggle;
    debugPrint("Toggle drawer===>$toggle");
    update();
  }

  int _offerSelectedIndex = 0;
  int get offerSelectedIndex => _offerSelectedIndex;

  void setOfferTypeIndex(int index){
    _offerSelectedIndex = index;
    update();
  }

  ProfileInfo? profileInfo;

  String driverName = '';
  String driverImage = '';
  String driverId = '';


  String isOnline = '0';
  Future<Response> getProfileInfo() async {
    isLoading = true;
    Response? response = await profileServiceInterface.getProfileInfo();
    if(response!.statusCode == 200){
      profileInfo = ProfileModel.fromJson(response.body).data!;
      Get.find<AuthController>().addImageAndRemoveMultiParseData();
      checkCashInHandWarningShow();
      driverId = profileInfo!.id!;
      driverImage = profileInfo!.profileImage??'';
      isOnline = profileInfo?.details?.isOnline ?? '0';
      oldDocuments = profileInfo?.documents;
      if (isOnline == "1") {
        if (kIsWeb) {
          startLocationRecord();
        } else {
          LocationPermission permission = await Geolocator.checkPermission();
          if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
              || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
            Get.dialog(ConfirmationDialogWidget(
              icon: Images.location,
              description: 'this_app_collects_location_data'.tr,
              onYesPressed: () {
                Get.back();
                _checkPermission(() => startLocationRecord());
              },
            ), barrierDismissible: false);
          }else {
            startLocationRecord();
          }
        }
      } else {
        stopLocationRecord();
      }
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }


  Future<void> getDailyLog() async {
    Response? response = await profileServiceInterface.dailyLog();
    if(response!.statusCode == 200){
      timeTrack = TimeTrack.fromJson(response.body['data']);
    }
    update();

  }

  Future<Response> updateProfile(
      String firstName, String lastName, String email, String identityNumber,
      List<String> services, String gender
      ) async {
    isLoading = true;
    update();

    await getAdditionalFieldValues();

    Response? response = await profileServiceInterface.updateProfileInfo(
        firstName: firstName, lastname: lastName, email: email,
        identityType: Get.find<AuthController>().identityType,
        identityNumber: identityNumber,
        profile:  Get.find<AuthController>().pickedProfileFile,
        identityImage:  Get.find<AuthController>().multipartList,
        services: services,
        oldDocuments:  oldDocuments ?? [],
        newDocuments:  Get.find<AuthController>().otherDocuments,
        gender: gender,
        additionalData: additionalData,
        additionalFiles: additionalFiles,
        oldAdditionalImages: oldAdditionalImages
    );
    if(response!.statusCode == 200){
      Get.back();
      showCustomSnackBar('profile_info_updated_successfully'.tr, isError: false);
      isLoading = false;
      getProfileInfo();
      Get.find<AuthController>().clearOtherDocuments();
      disposeAdditionalFields();
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
    return response;

  }

  Future<Response> profileOnlineOffline( bool value) async {
    isLoading = true;
    update();
    Response? response = await profileServiceInterface.profileOnlineOffline();
    if(response!.statusCode == 200){
      if(isOnline == "0"){
        isOnline = "1";
      }else if(isOnline == "1"){
        isOnline = "0";
      }
    }else{
      Get.back();
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }

  List<Brand> brandList = [];
  List<VehicleModels> modelList = [];
  int selectedBrandIndex = 0;
  int selectedBrandId = 0;
  int selectedModelId = 0;
  int selectedModelIndex = 0;
  List<int> brandIds = [];
  List<int> modelIds = [];

  Brand? selectedBrand;

  Future<Response> getVehicleBrandList(int offset) async {
    brandIds = [];
    brandIds.add(0);
    isLoading = true;
    Response? response = await profileServiceInterface.getVehicleBrandList(offset);
    if(response!.statusCode == 200){
      brandList = [];
      brandList.add(Brand(id: 'abc', name: 'select_brand_model'.tr, vehicleModels: []));
      brandList.addAll(VehicleBrandModel.fromJson(response.body).data!);

      int index = brandList.indexWhere((value)=> value.name == profileInfo?.vehicle?.brand?.name);
      if(index == -1){
        setBrandIndex(brandList[0], true);
      }else{
        setBrandIndex(brandList[index], true);
      }

    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;

  }

  void setBrandIndex(Brand brand, bool notify) {
    selectedBrand = brand;
    modelList = [];
    if(selectedBrand != null){
      modelList.add(VehicleModels(id: 'abc', name: 'select_vehicle_model'));
      modelList.addAll(selectedBrand!.vehicleModels!);

      int index = modelList.indexWhere((value)=> value.name == profileInfo?.vehicle?.model?.name);
      if(index == -1){
        selectedModel = modelList[0];
      }else{
        selectedModel = modelList[index];
      }

    }
    if(notify) {
      update();
    }
  }
  VehicleModels selectedModel = VehicleModels();
  void setModelIndex(VehicleModels model, bool notify) {
    selectedModel = model;
    if(notify) {
      update();
    }
  }


  String selectedFuelType = 'select_fuel_type';
  void setFuelType(String type, bool notify){
    selectedFuelType = type;
    if(notify){
      update();
    }
  }



  List<Category> categoryList =[];
  Future<void> getCategoryList(int offset) async {
    Response? response = await profileServiceInterface.getCategoryList(offset);
    if(response!.statusCode == 200 && response.body['data'] != null){
      categoryList = [];
      categoryList.add(Category(id: 'abc', name: 'select_vehicle_category'));
      categoryList.addAll(CategoryModel.fromJson(response.body).data!);
      int index = categoryList.indexWhere((value)=> value.name == profileInfo?.vehicle?.category?.name);
      if(index == -1){
        selectedCategory = categoryList[0];
      }else{
        selectedCategory = categoryList[index];
      }
    }else{
      isLoading = false;
     ApiChecker.checkApi(response);
    }
    update();
  }


  Category selectedCategory = Category();
  void setCategoryIndex(Category category, bool notify) {
    selectedCategory = category;
    if(notify) {
      update();
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void setStartDate(DateTime startDate){
    _startDate = startDate;
  }

  void selectDate(String type, BuildContext context){
    showDatePicker(
      cancelText: 'cancel'.tr,
      confirmText: 'ok'.tr,
      helpText: 'select_date'.tr,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
    ).then((date) {
      if (type == 'start'){
        if(date != null) _startDate = date;
      }else{
        if(date != null) _endDate = date;
      }
      update();
    });
  }


  bool creating = false;
  Future<void> addNewVehicle(VehicleBody vehicleBody) async {
    creating = true;
    update();
    Response? response = await profileServiceInterface.addNewVehicle(vehicleBody, documents);
    if(response!.statusCode == 200){
      creating = false;
      Get.find<ProfileController>().updateFaceVerificationBottomSheet(false);
      getProfileInfo().then((value) {
        if(value.statusCode == 200){
          Get.offAll(()=> const DashboardScreen());
          showCustomSnackBar('vehicle_added_successfully'.tr, isError: false);
        }
      });
    }else{
      creating = false;
      ApiChecker.checkApi(response);
    }
    creating = false;
    update();
  }

  Future<Response> updateVehicle(VehicleBody vehicleBody, String driverId) async {
    creating = true;
    update();
    Response? response = await profileServiceInterface.updateVehicle(vehicleBody, driverId);
    if(response!.statusCode == 200){
      creating = false;
      getProfileInfo().then((value) {
        if(value.statusCode == 200){
          showCustomSnackBar(response.body['message'], isError: false);
        }
      });
    }else{
      creating = false;
      ApiChecker.checkApi(response);
    }
    creating = false;
    update();
    return response;
  }

  void clearVehicleData(){
    listOfDocuments = [];
  }


  File? selectedFileForImport = File('');
  void setSelectedFileName(File fileName){
    selectedFileForImport = fileName;
    update();
  }


  Future<bool> pickOtherFile(bool isRemove) async {
    if(isRemove){
      _otherFile=null;
    }else{
      _otherFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withReadStream: !kIsWeb,
        allowedExtensions: ['csv', 'doc','jpeg','jpg','pdf','png','webp','xlsx', 'docx', 'zip'],
      );
      if (_otherFile != null) {
       if(await FileValidationHelper.validatePlatformFileSizeAsync(file: _otherFile!.files.single)){
         listOfDocuments.add(_otherFile!);
         objFile = _otherFile!.files.single;
         documents.add(MultipartDocument('upload_documents[]', objFile));
       }
      }
    }
    update();
    return true;
  }

  void removeFile(int index) async {
    listOfDocuments.removeAt(index);
    documents.removeAt(index);
    update();
  }

  Timer? _timer;
  final loc.Location _location = loc.Location();
  void startLocationRecord() {
    if(!kIsWeb) {
      _location.enableBackgroundMode(enable: true);
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      List<String> status = ['accepted', 'ongoing', 'out_for_pickup'];
      if(Get.find<RideController>().tripDetail != null && status.contains(Get.find<RiderMapController>().currentRideState.name) && Get.find<AuthController>().getUserToken() != ''){
        Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetail!.id!);
      }
      Get.find<LocationController>().getCurrentLocation(callZone: false);
    });
  }

  void stopLocationRecord() {
    if(!kIsWeb) {
      _location.enableBackgroundMode(enable: false);
    }
    _timer?.cancel();
  }

  void _checkPermission(Function callback) async {
    if(kIsWeb) {
      callback();
      return;
    }
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(ConfirmationDialogWidget(description: 'you_denied'.tr, onYesPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }, icon: Images.logo,), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(ConfirmationDialogWidget(description: 'you_denied_forever'.tr, onYesPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }, icon: Images.logo,), barrierDismissible: false);
    }else {
      callback();
    }
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  LevelModel? _levelModel;
  LevelModel? get levelModel => _levelModel;

 Future<void> getProfileLevelInfo() async{
   Response response = await profileServiceInterface.getProfileLevelInfo();
   if(response.statusCode == 200){
     _levelModel = LevelModel.fromJson(response.body);
   }else{
     ApiChecker.checkApi(response);
   }
   update();
 }

  void removeOldDocument(int index) async {
    oldDocuments?.removeAt(index);
    update();
  }

  void checkCashInHandWarningShow(){
   double payableBalance = (profileInfo?.wallet?.payableBalance ?? 0) - (profileInfo?.wallet?.receivableBalance ?? 0);
   double maxCashInHand = Get.find<SplashController>().config?.cashInHandMaxAmountHold ?? 0;
   double percentageCashInHand = maxCashInHand * 0.8;
   if((payableBalance >= percentageCashInHand) && (payableBalance < maxCashInHand) && (Get.find<SplashController>().config?.cashInHandSetupStatus ?? false)){
     isCashInHandHoldAccount = false;
     isCashInHandWarningShow = true;
   }else if((payableBalance >= maxCashInHand) && (Get.find<SplashController>().config?.cashInHandSetupStatus ?? false)){
     isCashInHandHoldAccount = true;
     isCashInHandWarningShow = false;
   }else{
     isCashInHandHoldAccount = false;
     isCashInHandWarningShow = false;
   }
  }

  void removeCashInHandWarnings(){
    isCashInHandHoldAccount = false;
    isCashInHandWarningShow = false;
    update();
  }

  void removeFaveVerificationSuspendWarning(){
   profileInfo?.isSuspended = false;
   update();
  }

  void loadAdditionalFields() {
   _additionalFields = Get.find<SplashController>().config?.additionalFieldList ?? [];

   for (var controller in _additionalFieldControllers.values) {
     controller.dispose();
   }
   for (var node in _additionalFieldFocusNodes.values) {
     node.dispose();
   }
   _additionalFieldControllers.clear();
   _additionalFieldFocusNodes.clear();
   _additionalFieldFiles.clear();
   _additionalFieldCheckValues.clear();
   _additionalFieldPhoneCountryCodes.clear();

   for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox) {
        if (field.options?.isNotEmpty == true) {
          _additionalFieldCheckValues[field.id] = <String>[];

          profileInfo?.additionalData?.forEach((additionData){
            if(additionData.title == field.title && additionData.type == field.fieldType.name){
              _additionalFieldCheckValues[field.id] = additionData.value ?? [];
            }
          });
        } else {
          _additionalFieldCheckValues[field.id] = false;

          profileInfo?.additionalData?.forEach((additionData){
            if(additionData.title == field.title && additionData.type == field.fieldType.name){
              _additionalFieldCheckValues[field.id] = (additionData.value?.isNotEmpty == true && additionData.value![0] == '1');
            }
          });
        }
       }
      else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        _additionalFieldCheckValues[field.id] = '';

        profileInfo?.additionalData?.forEach((additionData){
          if(additionData.title == field.title && additionData.type == field.fieldType.name){
            _additionalFieldCheckValues[field.id] = additionData.value?[0] ?? '';
          }
        });
     }
      else if (field.fieldType == AdditionalFieldType.file) {
       _additionalFieldFiles[field.id] = [];

       profileInfo?.additionalData?.forEach((additionData){
         if(additionData.title == field.title && additionData.type == field.fieldType.name){
           additionData.value?.forEach((v) {
             _additionalFieldFiles[field.id]?.add(v);
           });
         }
       });
     }
      else {
       _additionalFieldFocusNodes[field.id] = FocusNode();
       _additionalFieldControllers[field.id] = TextEditingController();

       if (field.fieldType == AdditionalFieldType.phone) {
         _additionalFieldPhoneCountryCodes[field.id] = CountryCode.fromCountryCode(Get.find<SplashController>().config!.countryCode!).dialCode ?? '+880';
       }

       profileInfo?.additionalData?.forEach((additionData){
         if(additionData.title == field.title && additionData.type == field.fieldType.name){
           String phoneWithCountry = additionData.value?[0] ?? '';
           if (field.fieldType == AdditionalFieldType.phone && phoneWithCountry.isNotEmpty) {
             String? countryCode = CountryCodeHelper.getCountryCode(phoneWithCountry);
             if (countryCode != null) {
               _additionalFieldPhoneCountryCodes[field.id] = countryCode;
               _additionalFieldControllers[field.id]?.text = phoneWithCountry.substring(countryCode.length);
             } else {
               _additionalFieldControllers[field.id]?.text = phoneWithCountry;
             }
           } else {
             _additionalFieldControllers[field.id]?.text = phoneWithCountry;
           }
         }
       });
     }
   }
  }

  void setAdditionalFieldPhoneCountryCode(String fieldId, String countryCode) {
    _additionalFieldPhoneCountryCodes[fieldId] = countryCode;
    update();
  }

  void setAdditionalFieldFile(String fieldId, List<dynamic> files) {
    _additionalFieldFiles[fieldId] = files;
    update();
  }

  void setAdditionalFieldCheckValue(String fieldId, dynamic value) {
    _additionalFieldCheckValues[fieldId] = value;
    update();
  }

  Future<Map<String, dynamic>> getAdditionalFieldValues() async{
    additionalFiles = [];
    additionalData.clear();
    oldAdditionalImages.clear();
    for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox || field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        additionalData[field.title] = _additionalFieldCheckValues[field.id] ?? (field.options?.isNotEmpty == true ? [] : false);
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id]?.forEach((file){
          if(file is XFile){
            additionalFiles.add(MultipartBody('additional_data[${field.title}][]', file));
          }else if(file is String){
            if (oldAdditionalImages[field.title] == null) {
              oldAdditionalImages[field.title] = <String>[];
            }
            oldAdditionalImages[field.title].add(file);
          }

        });
      } else {
        String value = _additionalFieldControllers[field.id]?.text.trim() ?? '';
        if (field.fieldType == AdditionalFieldType.phone && value.isNotEmpty) {
          value = (_additionalFieldPhoneCountryCodes[field.id] ?? '') + value;
        }
        additionalData[field.title] = value;
      }
    }
    return additionalData;
  }

  void disposeAdditionalFields() {
    for (var controller in _additionalFieldControllers.values) {
      controller.dispose();
    }
    for (var node in _additionalFieldFocusNodes.values) {
      node.dispose();
    }
    _additionalFieldControllers.clear();
    _additionalFieldFocusNodes.clear();
    _additionalFieldFiles.clear();
    _additionalFieldCheckValues.clear();
    additionalFiles = [];
    oldAdditionalImages = {};
  }

  String? validateAdditionalFields() {
    for (var field in _additionalFields) {
      if (!field.isRequired) continue;

      if (field.fieldType == AdditionalFieldType.checkbox) {
        final value = _additionalFieldCheckValues[field.id];
        if (field.options?.isNotEmpty == true) {
          if (value is! List || value.isEmpty) {
            return field.title;
          }
        } else {
          if (value != true) {
            return field.title;
          }
        }
      } else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        final value = _additionalFieldCheckValues[field.id] as String?;
        if (value == null || value.isEmpty) {
          return field.title;
        }
      } else if (field.fieldType == AdditionalFieldType.file) {
        if (_additionalFieldFiles[field.id] == null || _additionalFieldFiles[field.id]!.isEmpty) {
          return field.title;
        }
      } else {
        final value = _additionalFieldControllers[field.id]?.text.trim() ?? '';
        if (value.isEmpty) {
          return field.title;
        }
      }
    }
    return null;
  }
}