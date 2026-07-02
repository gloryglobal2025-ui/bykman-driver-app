import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer_widget.dart';
import 'package:ride_sharing_user_app/features/review/controllers/review_controller.dart';
import 'package:ride_sharing_user_app/features/review/widgets/review_card_widget.dart';
import 'package:ride_sharing_user_app/features/review/widgets/review_type_button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<ReviewController>().getReviewList(1);
    Get.find<ReviewController>().setReviewIndex(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (res,val){
          if(Get.find<ReviewController>().reviewTypeIndex == 1){
            Get.find<ReviewController>().setReviewIndex(0);
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
        child: Scaffold(
          body: GetBuilder<ReviewController>(builder: (reviewController) {
            return Stack(children: [
              Column(children: [
                AppBarWidget(
                    title: 'reviews'.tr,
                  onBackPressed: (){
                    if(Get.find<ReviewController>().reviewTypeIndex == 1){
                      Get.find<ReviewController>().setReviewIndex(0);
                    }else{
                      Get.back();
                    }
                  },
                ),
                const SizedBox(height: Dimensions.topBelowSpace),

                Expanded(
                  child: reviewController.reviewModel != null ?
                  (reviewController.reviewModel!.data != null &&
                      reviewController.reviewModel!.data!.isNotEmpty) ?
                  SingleChildScrollView(
                    controller: scrollController,
                    child: PaginatedListViewWidget(
                      scrollController: scrollController,
                      totalSize: reviewController.reviewModel!.totalSize,
                      offset: (reviewController.reviewModel != null && reviewController.reviewModel!.offset != null) ?
                      int.parse(reviewController.reviewModel!.offset.toString()) : null,
                      onPaginate: (int? offset) async {
                        if (kDebugMode) {
                          print('==========offset========>$offset');
                        }
                        await reviewController.getReviewList(offset);
                      },

                      itemView: ListView.builder(
                        itemCount: reviewController.reviewModel!.data!.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewCardWidget(review: reviewController.reviewModel!.data![index], index: index);
                        },
                      ),
                    ),
                  ) :
                  NoDataWidget(
                    title: reviewController.reviewTypeIndex ==0 ?
                    'no_review_found' : 'no_review_saved_yet',
                  ) :
                  const NotificationShimmerWidget(),
                ),
              ]),

              Positioned(top: Get.height * (GetPlatform.isIOS ? ResponsiveHelper.isTab ? 0.10 : 0.14 :  0.11), left: Dimensions.paddingSizeSmall,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(height: Dimensions.headerCardHeight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: reviewController.reviewTypeList.length,
                      itemBuilder: (context, index){
                        return SizedBox(width : Get.width/2.1,
                          child: ReviewTypeButtonWidget(
                            reviewType : reviewController.reviewTypeList[index], index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              )
            ]);
          }),
        ),
      ),
    );
  }
}
