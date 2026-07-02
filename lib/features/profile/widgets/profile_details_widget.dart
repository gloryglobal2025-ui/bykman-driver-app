import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/profile_item_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/profile_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({super.key});

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController){
      return Column(children: [
        Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
            ),
            child: Column(children:  [
              if(profileController.profileInfo?.details?.services != null)
                ProfileItemWidget(title: 'service',
                  value: profileController.profileInfo!.details!.services!.length == 1 ?
                  profileController.profileInfo!.details!.services![0].tr :
                  '${profileController.profileInfo!.details!.services![0].tr} & ${profileController.profileInfo!.details!.services![1].tr}',
                ),

              ProfileItemWidget(title: 'contact',
                value:Get.find<LocalizationController>().isLtr ?
                profileController.profileInfo?.phone ?? '' :
                '${profileController.profileInfo!.phone!.substring(1)}+',
              ),

              ProfileItemWidget(title: 'mail_address',
                value: profileController.profileInfo?.email ?? '',
              ),

              ProfileItemWidget(title: 'identification_type',
                value: profileController.profileInfo!.identificationType!.tr,
              ),

              ProfileItemWidget(title: 'identification_number',
                value: profileController.profileInfo?.identificationNumber ?? '',
              ),

              ProfileItemWidget(title: 'gender'.tr,
                value: profileController.profileInfo?.gender ?? '',
                isLastIndex: true,
              ),
            ]),
          ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        if(profileController.profileInfo?.identificationImage != null &&
            profileController.profileInfo!.identificationImage!.isNotEmpty )...[
          Align(alignment: Alignment.centerLeft, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Text('identity_images'.tr,style: textBold),
          )),

          GridView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,childAspectRatio: 1.5,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                crossAxisSpacing: Dimensions.paddingSize,
            ),
            shrinkWrap: true,
            itemCount : profileController.profileInfo!.identificationImage!.length ,
            itemBuilder: (BuildContext context, index){
              return ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                child: Image.network(
                  fit: BoxFit.cover,
                  '${Get.find<SplashController>().config!.imageBaseUrl!.identityImage}/${profileController.profileInfo!.identificationImage![index]}',
                    errorBuilder: (context, url, error) => Image.asset(Images.placeholder,  fit: BoxFit.cover)
                ),
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall)
        ],

        if (profileController.profileInfo!.isOldIdentificationImage!)...[
          Row(children: [
            const SizedBox(width: Dimensions.iconSizeMedium, child: Icon(Icons.error)),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text('identity_info_is_pending_for_approval'.tr,
              style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall)
        ],

          if(profileController.profileInfo?.documents != null &&
      profileController.profileInfo!.documents!.isNotEmpty )...[
            Align(alignment: Alignment.centerLeft, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text('other_documents'.tr,style: textBold),
            )),

            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (profileController.profileInfo?.documents ?? []).length,
              itemBuilder: (context, index){
                return _ImageAndDocumentView(
                  imageBaseUrl: Get.find<SplashController>().config?.imageBaseUrl?.documents ?? '',
                  imageUrl: profileController.profileInfo!.documents?[index] ?? '',
                  isDocument: true,
                );
              },
              separatorBuilder: (context, index){
                return const SizedBox(height: Dimensions.paddingSizeSmall);
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
        ],

        if((profileController.profileInfo?.additionalData ?? []).isNotEmpty)...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault).copyWith(bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (profileController.profileInfo?.additionalData ?? []).length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                if(profileController.profileInfo?.additionalData?[index].type == 'file'){
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(titleFormatedName(profileController.profileInfo?.additionalData?[index].title ?? ''), style: textBold),
                    const SizedBox(height: Dimensions.paddingSizeThree),

                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (profileController.profileInfo?.additionalData?[index].value ?? []).length,
                      itemBuilder: (context, idx){

                        bool isImage = AppConstants.allowedImageExtensions.contains((profileController.profileInfo?.additionalData?[index].value?[idx] ?? '').split('.').last);

                        return _ImageAndDocumentView(
                          imageBaseUrl: Get.find<SplashController>().config?.imageBaseUrl?.additionalData ?? '',
                          imageUrl: profileController.profileInfo?.additionalData?[index].value?[idx] ?? '',
                          isDocument: isImage ? false : true,
                        );
                      },
                      separatorBuilder: (context, index){
                        return const SizedBox(height: Dimensions.paddingSizeSmall);
                      },
                    )
                  ]);
                }else{
                  String data = '';
                  if(['checkbox', 'radio', 'select'].contains(profileController.profileInfo?.additionalData?[index].type)){
                    data = titleFormatedName((profileController.profileInfo?.additionalData?[index].value ?? []).join(", _"));
                  }else{
                    data = (profileController.profileInfo?.additionalData?[index].value ?? []).join(", ");
                  }

                  return ProfileItemWidget(
                    title: titleFormatedName(profileController.profileInfo?.additionalData?[index].title ?? ''),
                    value: data, isLastIndex: (profileController.profileInfo?.additionalData ?? []).length == (index +1),
                  );
                }
              },
            ),
          )
        ],

        GestureDetector(
          onTap: ()=>  Get.to(()=>const ResetPasswordScreen(
            phoneNumber: '',fromChangePassword: true,
          )),
          child: Text(Get.find<ProfileController>().profileInfo?.loggedInVia != 'otp' ? 'change_password'.tr : 'set_password'.tr, style: textRegular.copyWith(
              color: Theme.of(context).colorScheme.surfaceContainer,
              fontSize: Dimensions.fontSizeDefault,decorationColor: Theme.of(context).colorScheme.surfaceContainer,
              decoration: TextDecoration.underline
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
      ]);
    });
  }
}

class _ImageAndDocumentView extends StatelessWidget {
  final String imageBaseUrl;
  final String imageUrl;
  final bool isDocument;
  const _ImageAndDocumentView({required this.imageBaseUrl, required this.imageUrl, required this.isDocument});

  @override
  Widget build(BuildContext context) {
    return isDocument ?
    InkWell(
      onTap: () async{
        Get.find<HelpAndSupportController>().downloadFile(
            url: '$imageBaseUrl/$imageUrl}',
            fileName: imageUrl
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Image.asset(ProfileHelper.checkImageExtensions(imageUrl),height: 25,width: 25),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(imageUrl,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

              Text('click_to_view_the_file'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Theme.of(context).hintColor.withValues(alpha: 0.7)))
            ])
          ]),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                border: Border.all(color: Theme.of(context).primaryColor)
            ),
            child: Image.asset(Images.downloadIcon,height: 10,width: 10,color: Theme.of(context).primaryColor),
          )
        ]),
      ),
    ) :
    ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      child: ImageWidget(image: '$imageBaseUrl/$imageUrl', height: Get.height * 0.1),
    );
  }
}
