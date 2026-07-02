import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/help_and_support/controllers/help_and_support_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/type_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  @override
  void initState() {
    Get.find<HelpAndSupportController>().getPredefineFaqList();
    Get.find<HelpAndSupportController>().setHelpAndSupportIndex(0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (res,val){
        if(Get.find<HelpAndSupportController>().helpAndSupportIndex == 1){
          Get.find<HelpAndSupportController>().setHelpAndSupportIndex(0,isUpdate: true);
        }else{
          if(!res){
            if(Navigator.canPop(context)){
              Get.back();
            }else{
              Get.offAll(()=> const DashboardScreen());
            }
          }
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: GetBuilder<HelpAndSupportController>(builder: (helpAndSupportController) {
            String data =
                '${Get.find<SplashController>().config!.legal?.shortDescription??''}\n${Get.find<SplashController>().config!.legal?.longDescription??''}';
            return Stack(children: [
              Column(children: [
                AppBarWidget(
                    title: 'support_center'.tr, regularAppbar: false,
                  onBackPressed: (){
                    if(Get.find<HelpAndSupportController>().helpAndSupportIndex == 1){
                      Get.find<HelpAndSupportController>().setHelpAndSupportIndex(0,isUpdate: true);
                    }else{
                      Get.back();
                    }
                  }
                ),
                const SizedBox(height: 30),

                helpAndSupportController.helpAndSupportIndex == 0 ?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Center(
                      child: FutureBuilder<String>(
                          future: loadSvgAndChangeColors(Images.helpAndSupportGraphics, Theme.of(context).primaryColor),
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return SvgPicture.string(
                                  snapshot.data!
                              );
                            }
                            return SvgPicture.asset(Images.helpAndSupportGraphics);
                          }
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                    Text(
                      'we_love_to_hear_from_you'.tr,
                      style: textBold,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    InkWell(
                        onTap: ()=> _launchUrl("tel:${Get.find<SplashController>().config!.businessContactPhone!}",false),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 6, offset: Offset(0, 1))],
                          ),
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('call_our_customer_support'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                Image.asset(Images.call, color: Theme.of(context).primaryColor, height: 14, width: 14),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Text(Get.find<SplashController>().config!.businessContactPhone ?? '', style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                              ]),

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 1))],
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Image.asset(Images.callNewIcon, height: 16, width: 16),
                              )
                            ])
                          ]),
                        )
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    InkWell(
                        onTap: ()=> _launchUrl("sms:${Get.find<SplashController>().config!.businessContactEmail!}",true),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 6, offset: Offset(0, 1))],
                          ),
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('email_us_anytime'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Row(children: [
                                Icon(Icons.email, color: Theme.of(context).primaryColor, size: 14),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Text(Get.find<SplashController>().config!.businessContactEmail ?? '', style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                              ]),

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 1))],
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Image.asset(Images.gmailIcon, height: 16, width: 16),
                              )
                            ])
                          ]),
                        )
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    if(Get.find<SplashController>().config?.chattingSetupStatus ?? false)...[
                      Text(
                        'want_to_chat_with_us'.tr,
                        style: textBold,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      InkWell(
                          onTap: ()=> helpAndSupportController.createChannel(),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 6, offset: Offset(0, 1))],
                            ),
                            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('chat_with_support'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 1))],
                                ),
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Image.asset(Images.chatIcon, height: 16, width: 16),
                              )
                            ]),
                          )
                      ),
                    ]

                  ]),
                ) :
                Expanded(child: SingleChildScrollView(
                  padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  child: HtmlWidget(data, key: const Key( 'privacy_policy')),
                )) ,

              ]),

              Positioned(top: Get.height * (GetPlatform.isIOS ? ResponsiveHelper.isTab ? 0.10 : 0.14 :  0.11), left: 10,right: 10,
                child: SizedBox(height: Dimensions.headerCardHeight,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: helpAndSupportController.helpAndSupportTypeList.length,
                    itemBuilder: (context, index){
                      return TypeButtonWidget(
                          index: index,
                          name: helpAndSupportController.helpAndSupportTypeList[index],
                          selectedIndex: helpAndSupportController.helpAndSupportIndex,
                          cardWidth: Get.width/2.2,
                          onTap: () => helpAndSupportController.setHelpAndSupportIndex(index,isUpdate: true)
                      );
                    },
                  ),
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}

final Uri params = Uri(
  scheme: 'mailto',
  path: Get.find<SplashController>().config?.businessContactEmail,
  query: 'subject=support Feedback&body=',
);


Future<void> _launchUrl(String url, bool isMail) async {
  if (!await launchUrl(Uri.parse(isMail? params.toString() : url))) {
    throw 'Could not launch $url';
  }
}
