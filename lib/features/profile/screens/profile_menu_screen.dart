
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/biometric_auth_bottom_sheet_widget.dart';
import 'package:ride_sharing_user_app/features/html/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/screens/safety_setup_screen.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/payment_info_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/chat/screens/chat_screen.dart';
import 'package:ride_sharing_user_app/features/help_and_support/screens/help_and_support_screen.dart';
import 'package:ride_sharing_user_app/features/html/screens/policy_viewer_screen.dart';
import 'package:ride_sharing_user_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:ride_sharing_user_app/features/profile/screens/profile_screen.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/profile_level_widget.dart';
import 'package:ride_sharing_user_app/features/review/screens/review_screen.dart';
import 'package:ride_sharing_user_app/features/setting/screens/setting_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  @override
  void initState() {
    Get.find<RideController>().updateRoute(true, notify: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).primaryColor,
      body: Column(children: [
        const ProfileLevelWidgetWidget(),
        const SizedBox(height: 25),

        Expanded(child: SingleChildScrollView(child: Column(children: [
          ProfileMenuItem(icon: Images.profileIcon, title: 'profile',
            onTap: ()=> Get.to(()=> const ProfileScreen()),
          ),

          ProfileMenuItem(icon: Images.message, title: 'message',
            onTap: ()=>  Get.to(()=> const ChatScreen()),
          ),

          ProfileMenuItem(icon: Images.destinationIcon, title: 'my_reviews',
            onTap: ()=> Get.to(()=> const ReviewScreen()),
          ),

          ProfileMenuItem(title: 'safety', icon: Images.privacyPolicy,
            onTap: () => Get.to(() => const SafetySetupScreen()),
          ),

          ProfileMenuItem(icon: Images.leaderBoardIcon, title: 'leader_board',
            onTap: ()=> Get.to(()=> const LeaderboardScreen()),
          ),

          if((Get.find<SplashController>().config?.referralEarningStatus ?? false) ||
              ((Get.find<ProfileController>().profileInfo?.wallet?.referralEarn ?? 0)> 0))
          ProfileMenuItem(icon: Images.referralIcon1, title: 'refer&earn',
            onTap: ()=> Get.to(()=> const ReferAndEarnScreen()),
          ),

          ProfileMenuItem(icon: Images.leaderBoardIcon, title: 'add_withdraw_info',
            onTap: ()=> Get.to(()=> const PaymentInfoScreen()),
          ),

          if(Get.find<AuthController>().isBiometricSupported && (Get.find<SplashController>().config?.driverLoginOptions?.biometricLogin ?? false))
          ProfileMenuItem(icon: Images.biometricIcon, title: 'biometric_login', isAuth: true),

          ProfileMenuItem(icon: Images.helpAndSupportIcon, title: 'help_and_support',
            onTap: ()=> Get.to(()=> const HelpAndSupportScreen()),
          ),

          ProfileMenuItem(icon: Images.setting, title: 'setting',
            onTap: ()=> Get.to(()=> const SettingScreen()),
          ),

          ProfileMenuItem(icon: Images.privacyPolicy, title: 'privacy_policy',
            onTap: ()=> Get.to(()=>  PolicyViewerScreen(htmlType: HtmlType.privacyPolicy,
              image: Get.find<SplashController>().config?.privacyPolicy?.image??'',
            )),
          ),

          ProfileMenuItem(icon: Images.termsAndCondition, title: 'terms_and_condition',
            onTap: ()=> Get.to(()=>  PolicyViewerScreen(htmlType: HtmlType.termsAndConditions,
              image: Get.find<SplashController>().config?.termsAndConditions?.image??'',
            )),
          ),

          ProfileMenuItem(icon: Images.termsAndCondition, title: 'refund_policy',
            onTap: ()=> Get.to(()=>  PolicyViewerScreen(htmlType: HtmlType.refundPolicy,
              image: Get.find<SplashController>().config?.refundPolicy?.image??'',
            )),
          ),

          ProfileMenuItem(icon: Images.privacyPolicy, title: 'legal',
            onTap: ()=> Get.to(()=>  PolicyViewerScreen(htmlType: HtmlType.legal,
              image: Get.find<SplashController>().config?.legal?.image??'',
            )),
          ),


          ProfileMenuItem(icon: Images.logOutIcon, title: 'logout', onTap: (){
            Get.bottomSheet(GetBuilder<AuthController>(builder: (authController) {
              return ConfirmationBottomsheetWidget(
                icon: Images.exitIcon,
                iconColor: Theme.of(context).cardColor,
                isLoading: authController.logging,
                title: 'logout'.tr,
                description: 'do_you_want_to_log_out_this_account'.tr,
                onYesPressed: ()=> authController.logOut(),
                onNoPressed: ()=> Get.back(),
              );
            }));
          }),

          ProfileMenuItem(icon: Images.logOutIcon,
            title: 'permanently_delete_account'.tr, onTap: (){
            Get.bottomSheet(GetBuilder<AuthController>(builder: (authController) {
              return ConfirmationBottomsheetWidget(
                icon: Images.exitIcon,
                isLoading: authController.logging,
                iconColor: Theme.of(context).cardColor,
                isLogOut: true,
                title: 'delete_account'.tr,
                description: 'permanently_delete_confirm_msg'.tr,
                onNoPressed: ()=> Get.back(),
                onYesPressed: ()=> authController.permanentDelete(),
              );
            }));

            },
          ),
          const SizedBox(height: 100)
        ]))),
      ]),
    );
  }
}


class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? onTap;
  final bool isAuth;
  const ProfileMenuItem({super.key, required this.icon, required this.title, this.onTap, this.isAuth = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(children: [
            SizedBox(width: Dimensions.iconSizeLarge,
              child: Image.asset(icon, color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).cardColor),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Text(title.tr, style: textSemiBold.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge)),

            if(isAuth)...[
              const Spacer(),

              GetBuilder<AuthController>(builder: (authController){
                bool isBiometricOn = authController.isBiometricEnable;
                return FlutterSwitch(
                  height: 22,
                  width: 45,
                  value: isBiometricOn,
                  padding: 2,
                  activeColor: Theme.of(context).cardColor,
                  inactiveColor: Theme.of(context).cardColor,
                  activeToggleColor: Theme.of(context).primaryColor,
                  inactiveToggleColor: Theme.of(context).hintColor.withValues(alpha: 0.6),
                  onToggle: (value){
                    Get.bottomSheet(
                      backgroundColor: Theme.of(context).cardColor,
                      const BiometricAuthBottomSheetWidget(),
                    );
                  },
                );
              }),
              SizedBox(width: Get.width * 0.15)
            ]
          ]),
        ),
      ),
    );
  }
}


