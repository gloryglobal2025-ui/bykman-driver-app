import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DigitalPaymentScreen extends StatefulWidget {
  final String paymentMethod;
  final String totalAmount;
  const DigitalPaymentScreen({super.key, required this.paymentMethod, required this.totalAmount});

  @override
  State<DigitalPaymentScreen> createState() => _DigitalPaymentScreenState();
}

class _DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;


  PullToRefreshController? pullToRefreshController;
  late AddFundInAppBrowser browser;

  @override
  void initState() {
    super.initState();

    selectedUrl = '${AppConstants.baseUrl}${AppConstants.digitalPayment}?user_id=${Get.find<ProfileController>().profileInfo?.id}&amount=${widget.totalAmount}&payment_method=${widget.paymentMethod}';
    _initData();
  }

  void _initData() async {
    browser = AddFundInAppBrowser(context);
    final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(javaScriptEnabled: true, isInspectable: kDebugMode, useShouldOverrideUrlLoading: true, useOnLoadResource: true),
    );




    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl!)),
      settings: settings,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(canPop: false,
        onPopInvokedWithResult: (didPop, val) async {
          Get.back();
          return ;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text(''),backgroundColor: Theme.of(context).cardColor),
          body: Center(child: _isLoading ? SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,) : const SizedBox.shrink()),
        ),
      ),
    );
  }
}


class AddFundInAppBrowser extends InAppBrowser {
  final BuildContext context;

  AddFundInAppBrowser(this.context,  {
    super.windowId,
    super.initialUserScripts,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      Get.back();

      Future.delayed(Duration(microseconds: 500)).then((_){
        showCustomSnackBar('${'transaction_failed'.tr} !');
      });
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }





  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    Uri uri = navigationAction.request.url!;
    if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if(isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if(isSuccess){
        Get.back();
        showCustomSnackBar('${'amount_paid_successfully'.tr} !', isError: false);
        Get.find<ProfileController>().getProfileInfo();
      }else if(isFailed) {
        Get.back();
        Future.delayed(Duration(microseconds: 500)).then((_){
          showCustomSnackBar('${'transaction_failed'.tr} !');
        });

      }else if(isCancel) {
        Get.back();
        Future.delayed(Duration(microseconds: 500)).then((_){
          showCustomSnackBar('${'transaction_failed'.tr} !');
        });

      }
    }
  }
}