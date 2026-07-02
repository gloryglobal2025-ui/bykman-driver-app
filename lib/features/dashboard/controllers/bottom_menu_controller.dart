import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/util/images.dart';


class BottomMenuController extends GetxController implements GetxService{
  int _currentTab = 0;
  int get currentTab => _currentTab;


  void resetNavBar(){
    _currentTab = 0;
  }
  void setTabIndex(int index) {
    _currentTab = index;
    update();
  }

  void exitApp() {
    Get.bottomSheet(ConfirmationBottomsheetWidget(
      icon: Images.exitIcon,
      title: 'exit_app'.tr,
      description: 'do_you_want_to_exit_the_app'.tr,
      onYesPressed: (){
        SystemNavigator.pop();
        exit(0);
      },
      onNoPressed: ()=> Get.back(),
    ));
  }

}
