import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/home_screen_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';

class ProfileStatusCardWidget extends StatefulWidget {
  final ProfileController profileController;
  const ProfileStatusCardWidget({super.key, required this.profileController});

  @override
  State<ProfileStatusCardWidget> createState() => _ProfileStatusCardWidgetState();
}

class _ProfileStatusCardWidgetState extends State<ProfileStatusCardWidget> {
  JustTheController tooltipController = JustTheController();
  JustTheController faceTooltipController = JustTheController();
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_){
      if(widget.profileController.isCashInHandHoldAccount){
        tooltipController.showTooltip();
      }
      if(widget.profileController.profileInfo?.isVerified ?? false){
        faceTooltipController.showTooltip();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
          border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
        ),
        child:widget.profileController.profileInfo != null && widget.profileController.profileInfo!.firstName != null ?
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSize),
          child: Row(children: [
            SizedBox(child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              child: ImageWidget(width: 40,height: 40,
                image: '${Get.find<SplashController>().config!.imageBaseUrl!.profileImage}/${widget.profileController.profileInfo!.profileImage}',
              ),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Row(children: [
                Flexible(
                  child: Text(
                    '${widget.profileController.profileInfo?.firstName ?? ''}  ${widget.profileController.profileInfo?.lastName ?? ''}',
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: textBold.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                if(widget.profileController.isCashInHandHoldAccount)...[
                  JustTheTooltip(
                    backgroundColor: Get.isDarkMode ?
                    Theme.of(context).primaryColor :
                    Theme.of(context).textTheme.bodyMedium!.color,
                    controller: tooltipController,
                    preferredDirection: AxisDirection.down,
                    tailLength: 10,
                    tailBaseWidth: 20,
                    content: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Text(
                        'on_hold'.tr,
                        style: textRegular.copyWith(
                          color: Colors.white, fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.error
                      ),
                      padding: EdgeInsets.all(Dimensions.paddingSizeTiny),
                      child: Icon(Icons.block, color: Theme.of(context).cardColor, size: Dimensions.paddingSizeSmall),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall)
                ],


                JustTheTooltip(
                  backgroundColor: Get.isDarkMode ?
                  Theme.of(context).primaryColor :
                  Theme.of(context).textTheme.bodyMedium!.color,
                  controller: faceTooltipController,
                  preferredDirection: AxisDirection.down,
                  tailLength: 10,
                  tailBaseWidth: 20,
                  content: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Text(
                      (widget.profileController.profileInfo?.isVerified ?? false) ?
                      'verified'.tr : 'unverified'.tr,
                      style: textRegular.copyWith(
                        color: Colors.white, fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                  ),
                  child: Image.asset(
                    (widget.profileController.profileInfo?.isVerified ?? false) ?
                    Images.faceVerifiedIcon : Images.nonVerificationIcon,
                    height: 14, width: 14,
                  ),
                )
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              if(Get.find<SplashController>().config!.levelStatus!)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0, horizontal: Dimensions.paddingSizeExtraSmall,
                  ),
                  child: Text(
                    widget.profileController.profileInfo!.level != null ? widget.profileController.profileInfo!.level!.name!: '',
                    style: textRegular.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ])),

            FlutterSwitch(
              width: 90.0,
              height: 30.0,
              valueFontSize: 14.0,
              toggleSize: 28.0,
              value: widget.profileController.isOnline == "1",
              borderRadius: 30.0,
              padding: 3,
              activeColor: Theme.of(context).primaryColor.withValues(alpha: .1),
              toggleBorder: Border.all(width: 5, color: Colors.white.withValues(alpha: .75)),
              activeText: 'online'.tr,
              inactiveText: 'offline'.tr,
              activeTextColor: Theme.of(context).primaryColor,
              showOnOff: true,
              activeTextFontWeight: FontWeight.w700,
              toggleColor: Colors.green,
              onToggle: (val) async {
                int ridingCount = Get.find<RideController>().ongoingRideList?.length ?? 0;
                int parcelCount = Get.find<RideController>().parcelListModel?.totalSize ?? 0;
                if((ridingCount + parcelCount) > 0){
                  showCustomSnackBar('sorry_you_canot_go_offline'.tr);
                }else{
                  if(widget.profileController.isOnline == "1"){
                    Get.bottomSheet(ConfirmationBottomsheetWidget(
                      iconColor: Theme.of(context).cardColor,
                      title: 'do_you_want_to_turn_off_the_status'.tr,
                      description: 'if_you_turn_off_the_status_you_wouldnot_get_any_trips'.tr,
                      icon: Images.errorMessageIcon,
                      onYesPressed: () async{
                        Get.back();
                        Get.dialog(const LoaderWidget(), barrierDismissible: false);
                        await widget.profileController.profileOnlineOffline(val).then((value){
                          widget.profileController.getDailyLog();
                          if(value.statusCode == 200){
                            Get.back();
                          }
                        });
                      },
                      onNoPressed: ()=> Get.back(),
                    ));

                  }else{
                    Get.dialog(const LoaderWidget(), barrierDismissible: false);
                    await widget.profileController.profileOnlineOffline(val).then((value){
                      if(value.statusCode == 200){
                        widget.profileController.getDailyLog();
                        Get.back();
                        if((Get.find<SplashController>().config?.chooseVerificationWhenToTrigger == "before_going_online") && (Get.find<SplashController>().config?.verifyDriverIdentity ?? false)){
                            HomeScreenHelper().faceVerificationSheet();
                        }

                      }
                    });
                  }
                }

              }),
          ]),
        ) :
        const SizedBox(),
      ),
    );
  }
}
