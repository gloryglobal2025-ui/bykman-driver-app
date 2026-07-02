import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/text_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/signup_body.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/additional_field_widget.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/text_field_title_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/email_checker.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';
import 'package:ride_sharing_user_app/helper/profile_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OtpSignUpScreen2 extends StatelessWidget {
  final String phoneNumber;
  const OtpSignUpScreen2({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          return Column(children: [
            _buildAppBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Center(child: Text('provide_your_identity'.tr, style: textBold.copyWith(fontSize: 22))),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Center(child: Text(
                      'this_information_will_help'.tr,
                      style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // Profile Picture
                    Center(child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                      ),
                      child: Stack(alignment: AlignmentDirectional.center, clipBehavior: Clip.none, children: [
                        authController.pickedProfileFile == null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: const ImageWidget(
                            image: '',
                            height: 76,
                            width: 76,
                            placeholder: Images.personPlaceholder,
                          ),
                        )
                            : CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(File(authController.pickedProfileFile!.path)),
                        ),
                        Positioned(
                          right: 0,
                          bottom: -3,
                          child: InkWell(
                            onTap: () => authController.pickImage(false, true),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.camera_enhance_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    TextFieldTitleWidget(title: 'email'.tr, isRequired: true),
                    TextFieldWidget(
                      hintText: 'enter_your_email'.tr,
                      inputType: TextInputType.emailAddress,
                      prefixIcon: Images.email,
                      controller: authController.emailController,
                      focusNode: authController.emailNode,
                      nextFocus: authController.addressNode,
                      inputAction: TextInputAction.next,
                      autoFocus: authController.emailController.text.isEmpty,
                    ),

                    TextFieldTitleWidget(title: 'address'.tr, isRequired: true),
                    TextFieldWidget(
                      hintText: 'enter_your_address'.tr,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      prefixIcon: Images.location,
                      controller: authController.addressController,
                      focusNode: authController.addressNode,
                      nextFocus: authController.identityNumberNode,
                      inputAction: TextInputAction.next,
                    ),

                    TextFieldTitleWidget(title: 'identity_type'.tr, isRequired: true),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: .5,
                          color: Theme.of(context).hintColor.withValues(alpha: .7),
                        ),
                      ),
                      child: Row(children: [
                        Image.asset(Images.identityIcon, height: 20, width: 20),
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                        Expanded(
                          child: DropdownButton<String>(
                            hint: authController.identityType == ''
                                ? Text(
                              'select_identity_type'.tr,
                              style: textRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            )
                                : Text(
                              authController.identityType.tr,
                              style: textRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                            items: authController.identityTypeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.tr,
                                  style: textRegular.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => authController.setIdentityType(val!),
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),
                      ]),
                    ),

                    TextFieldTitleWidget(title: 'identification_number'.tr, isRequired: true),
                    TextFieldWidget(
                      hintText: 'enter_your_identity_number'.tr,
                      inputType: TextInputType.text,
                      prefixIcon: Images.identity,
                      controller: authController.identityNumberController,
                      focusNode: authController.identityNumberNode,
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Upload Identity Image
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(
                            'upload_identity_image'.tr,
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyMedium!.color!,
                            ),
                          ),
                          Text(
                            '*',
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ]),
                        Text(
                          '${AppConstants.allowedImageExtensions.map((e) => e).join(', ')} ${FileValidationHelper.getMaxFileSize(true)}',
                          style: textRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: authController.identityImages.length >= 2
                              ? 2
                              : authController.identityImages.length + 1,
                          itemBuilder: (context, index) {
                            return index == authController.identityImages.length
                                ? GestureDetector(
                              onTap: () => authController.pickImage(false, false),
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  strokeWidth: 1,
                                  dashPattern: const [5, 5],
                                  color: Theme.of(context).hintColor,
                                  radius: const Radius.circular(Dimensions.paddingSizeSmall),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault,),
                                  child: Column(children: [
                                    Image.asset(Images.galleryIcon, scale: 4),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Text(
                                      'click_to_add'.tr,
                                      style: textRegular.copyWith(
                                        color: Theme.of(context).colorScheme.surfaceContainer,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )
                                : Stack(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(Dimensions.paddingSizeExtraSmall),
                                    ),
                                    child: Image.file(
                                      File(authController.identityImages[index].path),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width / 4.3,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => authController.removeImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dimensions.paddingSizeDefault),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    // Other Documents
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'other_documents'.tr,
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyMedium!.color!,
                          ),
                        ),
                        Text(
                          '${AppConstants.registrationAllowExtensions.map((e) => e).join(', ')} ${FileValidationHelper.getMaxFileSize(false)}',
                          style: textRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: authController.otherDocuments.length >= 5
                                ? 5
                                : authController.otherDocuments.length + 1,
                            itemBuilder: (context, index) {
                              return index == authController.otherDocuments.length
                                  ? GestureDetector(
                                onTap: () => authController.pickOtherFile(),
                                child: Column(children: [
                                  DottedBorder(
                                    options: RoundedRectDottedBorderOptions(
                                      strokeWidth: 1,
                                      dashPattern: const [5, 5],
                                      color: Theme.of(context).hintColor,
                                      radius: const Radius.circular(Dimensions.paddingSizeSmall),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                          color: Theme.of(context).cardColor,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: Dimensions.paddingSizeDefault,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                            Image.asset(Images.cloudUploadIcon, scale: 3),
                                            Text(
                                              'select_a_file'.tr,
                                              style: textRegular.copyWith(
                                                color: Theme.of(context).colorScheme.surfaceContainer,
                                              ),
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeSmall),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ]),
                              )
                                  : Column(children: [
                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    strokeWidth: 1,
                                    dashPattern: const [5, 5],
                                    color: Theme.of(context).hintColor,
                                    radius: const Radius.circular(Dimensions.paddingSizeSmall),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                      vertical: Dimensions.paddingSizeLarge,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            spacing: Dimensions.paddingSizeSmall,
                                            children: [
                                              Image.asset(
                                                ProfileHelper.checkImageExtensions(
                                                  '${authController.otherDocuments[index].file?.name}',
                                                ),
                                                height: 30,
                                                width: 30,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${authController.otherDocuments[index].file?.name}',
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => authController.removeFile(index),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.highlight_remove_outlined,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                              ]);
                            },
                          ),
                        ),
                      ]),
                    ),

                    if(authController.additionalFields.isNotEmpty)...[
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        'provide_additional_info'.tr,
                        style: textBold.copyWith(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: authController.additionalFields.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          return AdditionalFieldWidget(
                            fieldModel: authController.additionalFields[index],
                            index: index,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  ],
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.paddingSizeLarge),
                  topLeft: Radius.circular(Dimensions.paddingSizeLarge),
                ),
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeDefault,
              ).copyWith(bottom: Dimensions.paddingSizeExtraLarge),
              child: authController.isLoading
                  ? Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0))
                  : ButtonWidget(
                buttonText: 'submit'.tr,
                radius: 50,
                onPressed: () async {
                  final String email = authController.emailController.text;
                final String address = authController.addressController.text;
                final String identityNumber = authController.identityNumberController.text;

                if (authController.pickedProfileFile == null) {
                  showCustomSnackBar('profile_image_is_required'.tr);
                } else if (email.isEmpty) {
                  showCustomSnackBar('email_is_required'.tr);
                  FocusScope.of(context).requestFocus(authController.emailNode);
                } else if (EmailChecker.isNotValid(email)) {
                  showCustomSnackBar('enter_valid_email_address'.tr);
                  FocusScope.of(context).requestFocus(authController.emailNode);
                } else if (address.isEmpty) {
                  showCustomSnackBar('address_is_required'.tr);
                  FocusScope.of(context).requestFocus(authController.addressNode);
                } else if (authController.identityType.isEmpty) {
                  showCustomSnackBar('identity_type_is_required'.tr);
                } else if (identityNumber.isEmpty) {
                  showCustomSnackBar('identity_number_is_required'.tr);
                  FocusScope.of(context).requestFocus(authController.identityNumberNode);
                } else if (authController.identityImages.isEmpty) {
                  showCustomSnackBar('identity_image_is_required'.tr);
                } else {
                  final String? invalidField = authController.validateAdditionalFields();
                  if (invalidField != null) {
                    showCustomSnackBar('${titleFormatedName(invalidField)} ${'is_required'.tr}');
                    return;
                  }

                  String? deviceToken = await FirebaseMessaging.instance.getToken();
                  SignUpBody signUpBody = SignUpBody(
                    fName: authController.fNameController.text.trim(),
                    lName: authController.lNameController.text.trim(),
                    phone: phoneNumber,
                    email: email.trim(),
                    address: address.trim(),
                    identificationType: authController.identityType,
                    identityNumber: identityNumber.trim(),
                    referralCode: authController.referralCodeController.text.trim(),
                    gender: authController.selectedGender,
                    services: () {
                      List<String> services = [];
                      if (authController.isRideShare) services.add('ride_request');
                      if (authController.isParcelShare) services.add('parcel');
                      return services;
                    }(),
                    fcmToken: deviceToken,
                  );
                  authController.registerWithOtp(signUpBody, updateFromRegistration: false);
                }
                },
              ),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(children: [
        AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            color: Theme.of(context).textTheme.bodyMedium?.color,
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'setup_profile'.tr,
            style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        Container(height: 3, color: Theme.of(context).primaryColor),
      ]),
    );
  }
}
