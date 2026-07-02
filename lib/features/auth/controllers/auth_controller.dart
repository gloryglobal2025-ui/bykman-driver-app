import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/verification_from_enum.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/additional_field_model.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:ride_sharing_user_app/features/auth/screens/otp_sign_up-screen_1.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/manual_auth_waring_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/features/map/controllers/otp_time_count_controller.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/controllers/out_of_zone_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/helper/country_code_picke.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';
import 'package:ride_sharing_user_app/helper/login_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/approve_dialog_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/features/location/screens/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/snackbar_widget.dart';


class AuthController extends GetxController with WidgetsBindingObserver implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}){
    _checkBiometricSupport();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_settingsCompleter != null && !_settingsCompleter!.isCompleted) {
        _settingsCompleter!.complete();
      }
    }
  }

  Completer<void>? _settingsCompleter;



  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _isOtpSending = false;
  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;
  bool get isOtpSending => _isOtpSending;
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;
  XFile? _pickedProfileFile ;
  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile identityImage = XFile('');
  List<XFile> identityImages = [];
  List<MultipartBody> multipartList = [];
  List<MultipartDocument> otherDocuments = [];
  FilePickerResult? _otherFile;
  PlatformFile? objFile;
  String countryDialCode = '+880';
  bool isParcelShare = true;
  bool isRideShare = true;
  String selectedGender = 'select_gender';
  List<String> genderList = ['select_gender','male', 'female', 'other'];

  bool _isBiometricSupported = false;
  bool get isBiometricSupported => _isBiometricSupported;
  bool _biometric = false;
  bool get isBiometricEnable => _biometric;
  List<BiometricType> _bioList = [];
  List<BiometricType> get bioList => _bioList;

  List<AdditionalFieldModel> _additionalFields = [];
  List<AdditionalFieldModel> get additionalFields => _additionalFields;

  Map<String, TextEditingController> _additionalFieldControllers = {};
  Map<String, TextEditingController> get additionalFieldControllers => _additionalFieldControllers;

  Map<String, FocusNode> _additionalFieldFocusNodes = {};
  Map<String, FocusNode> get additionalFieldFocusNodes => _additionalFieldFocusNodes;
  Map<String, List<XFile>> _additionalFieldFiles = {};
  Map<String, List<XFile>> get additionalFieldFiles => _additionalFieldFiles;
  Map<String, dynamic> _additionalFieldCheckValues = {};
  Map<String, dynamic> get additionalFieldCheckValues => _additionalFieldCheckValues;
  Map<String, String> _additionalFieldPhoneCountryCodes = {};
  Map<String, String> get additionalFieldPhoneCountryCodes => _additionalFieldPhoneCountryCodes;

  final Map<String, dynamic> additionalData = {};
  List<MultipartBody> additionalFiles = [];

  void setCountryCode(String code){
    countryDialCode = code;
    update();
  }

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();
  FocusNode referralNode = FocusNode();


  void addImageAndRemoveMultiParseData(){
    multipartList.clear();
    identityImages.clear();
    update();
  }

  void updateServiceType(bool ride){
    if(ride){
      isRideShare = !isRideShare;
    }else{
      isParcelShare = !isParcelShare;
    }
    update();
  }

  void pickImage(bool isBack, bool isProfile) async {
       if(isProfile){
        _pickedProfileFile = (await FileValidationHelper.validateAndPickImage(source: ImageSource.gallery))!;
      } else{
         identityImage = (await FileValidationHelper.validateAndPickImage(source: ImageSource.gallery))!;
         identityImages.add(identityImage);
         multipartList.add(MultipartBody('identity_images[]', identityImage));
      }
    update();
  }

  void removeImage(int index){
    identityImages.removeAt(index);
    multipartList.removeAt(index);
    update();
  }

  Future<bool> pickOtherFile() async {
    _otherFile = (await FilePicker.pickFiles(
      type: FileType.custom,
      withReadStream: true,
      allowedExtensions: AppConstants.registrationAllowExtensions,
    ))!;
    if (_otherFile != null) {
      if(await FileValidationHelper.validatePlatformFileSizeAsync(file: _otherFile!.files.single)){
        objFile = _otherFile!.files.single;
        otherDocuments.add(MultipartDocument('upload_documents[]', objFile));
      }
    }
    update();
    return true;
  }

  void removeFile(int index) async {
    otherDocuments.removeAt(index);
    update();
  }

  void clearOtherDocuments() {
    otherDocuments.clear();
  }

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid', ];
  List<String> get identityTypeList => _identityTypeList;
  String _identityType = '';
  String get identityType => _identityType;

  void setIdentityType (String setValue, {bool isUpdate = true}){
    _identityType = setValue;
    if(isUpdate){
      update();
    }
  }

  Future<void> login(String countryCode, String phone, String password) async {
    _isLoading = true;
    update();
    final String fullPhoneNumber = countryCode + phone;

    Response? response = await authServiceInterface.login( phone: fullPhoneNumber, password: password);

    if(response!.statusCode == 200){
      disposeAdditionalFields();
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);
      PusherHelper.initializePusher();
      updateToken().then((value) {
        Get.find<OutOfZoneController>().getZoneList();
        _navigateLogin(countryCode, phone,password);
      });
      _isLoading = false;
    }else if(response.statusCode == 202){
      if(response.body['data']['is_phone_verified'] == 0){

        final bool isPhoneNotVerified = response.body['data']['is_phone_verified'] == 0;


        if (isPhoneNotVerified) {
          if (Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false) {
            firebaseOtpSend(countryCode: countryCode, number: phone, from: VerificationForm.login);
          } else if(Get.find<SplashController>().config?.isSmsGateway ?? false){
            sendOtp(countryCode: countryCode, number: phone).then((_){
              Get.to(() => VerificationScreen( countryCode:countryCode, number: phone, form: VerificationForm.login));
            });

          }else{
            showCustomSnackBar('sms_gateway_not_integrate'.tr);
          }
        }
      }
    }else if(response.statusCode == 408){
      Get.bottomSheet(ManualAuthWaringBottomSheetWidget(phoneNumber: phone, from: VerificationForm.resetPassword));
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  bool logging = false;
  Future<void> logOut() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.logOut();
    if(response!.statusCode == 200){
      Get.find<RideController>().updateRoute(false, notify: true);
      Get.find<ProfileController>().stopLocationRecord();
      logging = false;
      Get.back();
      LoginHelper.checkLoginMedium();

      PusherHelper().pusherDisconnectPusher();
      Get.find<SafetyAlertController>().cancelDriverNeedSafetyStream();
    }else{
      logging = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> permanentDelete() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.permanentDelete();
    if(response!.statusCode == 200){
      Get.find<RideController>().updateRoute(false, notify: true);
      Get.find<ProfileController>().stopLocationRecord();
      logging = false;
      Get.back();
      LoginHelper.checkLoginMedium();
      Get.find<SafetyAlertController>().cancelDriverNeedSafetyStream();
      showCustomSnackBar('successfully_delete_account'.tr, isError: false);
    }else{
      logging = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> register(String code, SignUpBody signUpBody) async {
    final ConfigModel? configModel = Get.find<SplashController>().config;

    await getAdditionalFieldValues();

    _isLoading = true;
    update();
    Response? response = await authServiceInterface.registration(
        signUpBody: signUpBody,
        profileImage: pickedProfileFile,
        identityImage: multipartList,
        documents: otherDocuments,
        additionalData: additionalData,
        additionalFiles: additionalFiles
    );
    if(response!.statusCode == 200){

      if(configModel?.verification ?? false){
        if (configModel?.isFirebaseOtpVerification ?? false) {
          Get.find<AuthController>().firebaseOtpSend(
            countryCode: code,
            number: signUpBody.phone?.replaceAll(code, '') ?? '',
            from: VerificationForm.login,
          );

        } else if(configModel?.isSmsGateway ?? false){
          sendOtp(countryCode: code, number: signUpBody.phone?.replaceAll(code, '') ?? '').then((_){
            Get.to(()=> VerificationScreen(
              countryCode: code,
              number: signUpBody.phone?.replaceAll(code, '') ?? '',
              form: VerificationForm.login,
            ));
          });

        }else{
        showCustomSnackBar('sms_gateway_not_integrate'.tr);
      }

      }else{
        showCustomSnackBar('registration_completed_successfully'.tr, isError: false);
        login(code, signUpBody.phone?.replaceAll(code, '') ?? '', signUpBody.password ?? '');
      }
      Get.find<ProfileController>().updateFirstTimeShowBottomSheet(true);
    }else if(response.statusCode == 407){
      Get.bottomSheet(ManualAuthWaringBottomSheetWidget(phoneNumber: signUpBody.phone?.replaceAll(code, '') ?? '', from: VerificationForm.verifyUser));
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void _navigateLogin(String code,String phone, String password) async{
    if (_isActiveRememberMe) {
      saveUserCredential(code ,phone, password);
    } else {
      clearUserCredential();
    }

    String localData = await getBiometricCountry() + await getBiometricPhone();

    if(localData != code+phone){
      _biometric = false;
      authServiceInterface.setBiometricEnabled(false);
    }

    Get.find<ProfileController>().getProfileInfo().then((value){
      if(value.statusCode == 200){
        if(Get.find<AuthController>().getZoneId() == ''){
          Get.offAll(()=> const AccessLocationScreen());
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
        PusherHelper().driverTripRequestSubscribe(value.body['data']['id']);

      }

    });
  }

  Future<Response> checkOAuth({required String countryCode,  required String number}) async{
    _isOtpSending = true;
    update();
    Response? response = await authServiceInterface.isUserRegistered(phone: countryCode+number);
    if(response!.statusCode == 200){
      _isOtpSending = false;
    }else{
      _isOtpSending = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> sendOtp({required String countryCode,  required String number}) async{
    _isOtpSending = true;
    update();
    Response? response = await authServiceInterface.sendOtp(phone: countryCode+number);
    if(response!.statusCode == 200){
      _isOtpSending = false;
      showCustomSnackBar('otp_sent_successfully'.tr, isError: false);
    }else{
      _isOtpSending = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> firebaseOtpSend({required String countryCode, required String number, bool canRoute = true, required VerificationForm from})async {
    _isOtpSending = true;
    update();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + number,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        _isOtpSending = false;
        update();

        if(e.code == 'invalid-phone-number') {
          showCustomSnackBar('please_submit_a_valid_phone_number'.tr);
        }else{
          showCustomSnackBar(e.message?.replaceAll('_', ' ') ?? '');
        }

      },
      codeSent: (String vId, int? resendToken) {

        _isOtpSending = false;
        update();
        if(canRoute){
          Get.to(() =>  VerificationScreen(countryCode: countryCode, number: number, session: vId, form: from));
        }

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }

  Future<void> registerWithOtp(SignUpBody signUpBody, {required bool updateFromRegistration}) async {
    _isLoading = true;
    update();

    await getAdditionalFieldValues();

    Response? response = await authServiceInterface.registerWithOtp(
        signUpBody: signUpBody,
        profileImage: pickedProfileFile,
        identityImage: multipartList,
        documents: otherDocuments,
        updateFromRegistration: updateFromRegistration,
        additionalData: additionalData,
        additionalFiles: additionalFiles
    );
    if(response!.statusCode == 200){
      disposeAdditionalFields();
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);
      PusherHelper.initializePusher();
      updateToken().then((value) {
        Get.find<OutOfZoneController>().getZoneList();
        String countryCode = CountryCodeHelper.getCountryCode(signUpBody.phone) ?? '';
        _navigateLogin(countryCode, signUpBody.phone?.replaceAll(countryCode, '') ?? '' , signUpBody.password ?? '');
      });
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<Response?> otpVerification(String phoneNumber, String otp,  {String password = '', required VerificationForm from, String? session}) async{
    _isLoading = true;
    update();

    Response? response;
    if(Get.find<SplashController>().config?.isFirebaseOtpVerification ?? false){
      response = await authServiceInterface.verifyFirebaseOtp(phone: phoneNumber, otp: otp,session: session!);
    }else{
      response = await authServiceInterface.verifyOtp(phone: phoneNumber, otp: otp);
    }


    if(response?.statusCode == 200){
      clearVerificationCode();
      _isLoading = false;
      if(from == VerificationForm.signUp){
        showDialog(context: Get.context!, builder: (_)=> ApproveDialogWidget(
            icon: Images.waitForVerification,
            description: 'create_account_approve_description'.tr,
            title: 'registration_not_approve_yet'.tr,
            onYesPressed: (){
              String countryCode = CountryCodeHelper.getCountryCode(phoneNumber) ?? '';
              login(countryCode, phoneNumber.replaceAll(countryCode, ''), password);
            }), barrierDismissible: false);
      }else if(from == VerificationForm.login){
        Map map = response?.body;
        String token = '';
        token = map['data']['token'];
        setUserToken(token);
        _isLoading = false;
        updateToken().then((value){
          Get.find<OutOfZoneController>().getZoneList();
         String countryCode = CountryCodeHelper.getCountryCode(phoneNumber) ?? '';
          _navigateLogin(countryCode, phoneNumber.replaceAll(countryCode, ''), password);
        });
      }else if(from == VerificationForm.verifyUser){
        List<String> services = [];
        if(isRideShare){
          services.add('ride_request');
        }
        if(isParcelShare){
          services.add('parcel');
        }
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        _isLoading = false;
        registerWithOtp(
          SignUpBody(
              email: emailController.text,
              address: addressController.text,
              identityNumber: identityNumberController.text,
              identificationType: identityType,
              fName: fNameController.text,
              lName: lNameController.text,
              phone: countryDialCode + phoneController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              services: services,
              referralCode: referralCodeController.text.trim(),
              fcmToken: deviceToken,
              gender: selectedGender
          ),updateFromRegistration: true
        );
      }else{
        Get.to(()=> ResetPasswordScreen(phoneNumber: phoneNumber));
      }
    }else if(response?.statusCode == 406){
      _isLoading = false;
      Get.off(()=> OtpSignUpScreen1(phoneNumber: phoneNumber));
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response!);
    }
    update();
    return response;
  }

  Future<void> forgetPassword(String phone) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.forgetPassword(phone);
    if (response!.statusCode  == 200) {
      _isLoading = false;
      snackBarWidget('successfully_sent_otp'.tr, isError: false);
    }else{
      _isLoading = false;
      snackBarWidget('invalid_number'.tr);
    }
    update();
  }

  Future<void> resetPassword(String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.resetPassword(phone, password);
    if (response!.statusCode == 200) {
      snackBarWidget('password_change_successfully'.tr, isError: false);
      LoginHelper.checkLoginMedium();
      updateBiometricPin(password);
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> changePassword(String password, String newPassword) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.changePassword(password, newPassword);
    if (response!.statusCode == 200) {
      snackBarWidget('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const DashboardScreen());
      updateBiometricPin(password);
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  bool updateFcm = false;
  Future<void> updateToken() async {
    updateFcm = true;
    update();
    Response? response =  await authServiceInterface.updateToken();
    if(response?.statusCode == 200){
      updateFcm = false;
    }else{
      updateFcm = false;
      ApiChecker.checkApi(response!);
    }
    update();
  }

  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode({bool isUpdate = true}){
    _otp = '';
    _verificationCode = '';
    if(isUpdate){
      update();
    }
  }

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> clearSharedData() async{
    return authServiceInterface.clearSharedData();
  }

  void saveUserCredential(String code,String number, String password) {
    authServiceInterface.saveUserCredential(code, number, password);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getUserCountryCode() {
    return authServiceInterface.getUserCountryCode();
  }

  String getLoginCountryCode() {
    return authServiceInterface.getLoginCountryCode();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  bool isNotificationActive() {
    return authServiceInterface.isNotificationActive();
  }

  void toggleNotificationSound(){
    authServiceInterface.toggleNotificationSound(!isNotificationActive());
    update();
  }

  Future<bool> clearUserCredential() async {
    return authServiceInterface.clearUserCredentials();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String getDeviceToken() {
    return authServiceInterface.getDeviceToken();
  }

  Future <void> setUserToken(String token) async{
    authServiceInterface.saveUserToken(token, getZoneId());
  }

  Future <void> updateZoneId(String zoneId) async{
    authServiceInterface.updateZone(zoneId);
  }

  String getZoneId() {
    return authServiceInterface.getZonId();
  }

  void saveRideCreatedTime(){
    authServiceInterface.saveRideCreatedTime(DateTime.now());
  }

  void remainingTime() async{
    String time = await authServiceInterface.remainingTime();
    if(time.isNotEmpty){
      DateTime oldTime = DateTime.parse(time);
      DateTime newTime = DateTime.now();
      int diff =  newTime.difference(oldTime).inSeconds;
      Get.find<OtpTimeCountController>().resumeCountingTime(diff);
    }
  }

  void setGender(String? value, {bool isUpdate = true}){
    selectedGender = value ?? 'select_gender';
    if(isUpdate){
      update();
    }
  }

  void loadAdditionalFields(bool fromOtp) {
    _additionalFields = [];
    if(fromOtp){
      (Get.find<SplashController>().config?.additionalFieldList ?? []).forEach((field){
        if(field.isRequired){
          _additionalFields.add(field);
        }
      });
    }else{
      _additionalFields = Get.find<SplashController>().config?.additionalFieldList ?? [];
    }
    _initAdditionalFieldControllers();
  }

  void _initAdditionalFieldControllers() {
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
        } else {
          _additionalFieldCheckValues[field.id] = false;
        }
      } else if (field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        _additionalFieldCheckValues[field.id] = '';
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id] = [];
      } else {
        _additionalFieldControllers[field.id] = TextEditingController();
        _additionalFieldFocusNodes[field.id] = FocusNode();
        if (field.fieldType == AdditionalFieldType.phone) {
          _additionalFieldPhoneCountryCodes[field.id] = CountryCode.fromCountryCode(Get.find<SplashController>().config!.countryCode!).dialCode ?? '+880';
        }
      }
    }
  }

  void setAdditionalFieldPhoneCountryCode(String fieldId, String countryCode) {
    _additionalFieldPhoneCountryCodes[fieldId] = countryCode;
    update();
  }

  void setAdditionalFieldFile(String fieldId, List<XFile> files) {
    _additionalFieldFiles[fieldId] = files;
    update();
  }

  void setAdditionalFieldCheckValue(String fieldId, dynamic value) {
    _additionalFieldCheckValues[fieldId] = value;
    update();
  }


  Future<Map<String, dynamic>> getAdditionalFieldValues() async{
    additionalFiles = [];
    for (var field in _additionalFields) {
      if (field.fieldType == AdditionalFieldType.checkbox || field.fieldType == AdditionalFieldType.radio || field.fieldType == AdditionalFieldType.select) {
        additionalData[field.title] = _additionalFieldCheckValues[field.id] ?? (field.options?.isNotEmpty == true ? [] : false);
      } else if (field.fieldType == AdditionalFieldType.file) {
        _additionalFieldFiles[field.id]?.forEach((file){
          additionalFiles.add(MultipartBody('additional_data[${field.title}][]', file));
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

  void disposeAdditionalFields() {
    for (var controller in _additionalFieldControllers.values) {
      controller.dispose();
    }
    for (var node in _additionalFieldFocusNodes.values) {
      node.dispose();
    }
    _additionalFieldControllers = {};
    _additionalFieldFocusNodes = {};
    _additionalFieldFiles = {};
    _additionalFieldCheckValues = {};
    additionalFiles = [];
    _additionalFieldPhoneCountryCodes = {};
    fNameController.clear();
    lNameController.clear();
    passwordController.clear();
    phoneController.clear();
    confirmPasswordController.clear();
    emailController.clear();
    addressController.clear();
    identityNumberController.clear();
    referralCodeController.clear();
    _pickedProfileFile = null ;
    identityImages = [];
    multipartList = [];
    otherDocuments = [];
  }

  ///For Biometric Login.....

  void _checkBiometricSupport() async {
    _biometric = await authServiceInterface.isBiometricEnabled();

    final LocalAuthentication bioAuth = LocalAuthentication();
    _bioList = await bioAuth.getAvailableBiometrics();
    _isBiometricSupported = await bioAuth.canCheckBiometrics;
  }

  Future<void> goToSettings() async {
    final LocalAuthentication bioAuth = LocalAuthentication();
    _bioList = await bioAuth.getAvailableBiometrics();
    if(_bioList.isEmpty && (_settingsCompleter == null || _settingsCompleter!.isCompleted)){
      try{
        _settingsCompleter = Completer<void>();
        await AppSettings.openAppSettings(type: AppSettingsType.lockAndPassword);
        await _settingsCompleter!.future;
        _bioList = await bioAuth.getAvailableBiometrics();
        update();
      }catch(e){
        debugPrint('error ===> $e');
      } finally {
        _settingsCompleter = null;
      }
    }
  }

  bool setBiometricEnable(bool isActive, String password) {

    authServiceInterface.pinVerify(password).then((response) async {
      if(response.statusCode == 200 && response.body != null) {
        _biometric = isActive;
        authServiceInterface.setBiometricEnabled(isActive && _bioList.isNotEmpty);
        try{
          authServiceInterface.addOrUpdateOnLocalDatabase(AppConstants.biometricPin, password);
        }catch(error) {
          debugPrint('error ===> $error');
        }
        Get.back();
        update();
      }else{
        ApiChecker.checkApi(response);
      }
    });

    return _biometric;
  }

  Future<void> updateBiometricPin(String password) async {
    await authServiceInterface.addOrUpdateOnLocalDatabase(AppConstants.biometricPin, password);
  }

  Future<String> getBiometricPin() async {
    return await  authServiceInterface.getDataFromLocalDatabase(AppConstants.biometricPin);
  }


  Future<bool> authenticateWithBiometric(String localizedReason) async {
    final LocalAuthentication bioAuth = LocalAuthentication();
    bool didAuthenticate = false;
    _bioList = await bioAuth.getAvailableBiometrics();

    if (_bioList.isNotEmpty) {
      try {
        didAuthenticate = await bioAuth.authenticate(
          localizedReason: localizedReason,
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
      } catch(e) {
        bioAuth.stopAuthentication();
      }
    }

    return didAuthenticate;
  }

  Future<String> getBiometricPhone(){
    return authServiceInterface.getBiometricPhone(AppConstants.userNumber);
  }

  Future<String> getBiometricCountry(){
    return authServiceInterface.getBiometricPhone(AppConstants.countryCode);
  }

  void loginWithBiometric() async {
    final isAbleToLogin = (isBiometricEnable && bioList.isNotEmpty);

    if(isAbleToLogin && await authenticateWithBiometric('please_authenticate_to_login'.tr)){
      login(
        await getBiometricCountry(),
        await getBiometricPhone(),
        await getBiometricPin(),
      );

    }
  }

}