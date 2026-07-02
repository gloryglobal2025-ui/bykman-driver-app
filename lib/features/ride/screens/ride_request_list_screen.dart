import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/widgets/customer_ride_request_card_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_view_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  @override
  void initState() {
    Get.find<RideController>().getPendingRideRequestList(1);
    super.initState();
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBarWidget(title: 'trip_request'.tr, regularAppbar: true,),
        body: GetBuilder<RideController>(builder: (rideController) {
            return Column(children: [
              if(rideController.pendingRideRequestModel?.data?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgPicture.asset(Images.leftSwipeIcon, height: 14,width: 14),

                  Text(
                    'swipe_to_reject'.tr,
                    style: textRegular.copyWith(color: Theme.of(Get.context!).colorScheme.error),
                  ),
                ]),
              ),

              Expanded(
                child: RefreshIndicator (
                  onRefresh: () async{
                    rideController.getPendingRideRequestList(1);
                  },
                  child: !rideController.isLoading ?
                  (rideController.pendingRideRequestModel!= null && rideController.pendingRideRequestModel!.data != null && rideController.pendingRideRequestModel!.data!.isNotEmpty) ?
                  SingleChildScrollView(
                    controller: scrollController,
                    child: PaginatedListViewWidget(
                      scrollController: scrollController,
                      totalSize: rideController.pendingRideRequestModel!.totalSize,
                      offset: rideController.pendingRideRequestModel != null && rideController.pendingRideRequestModel!.offset != null? int.parse(rideController.pendingRideRequestModel!.offset.toString()) : 1,
                      onPaginate: (int? offset) async {
                        await rideController.getPendingRideRequestList(offset!);
                      },

                      itemView: ListView.builder(
                        itemCount: rideController.pendingRideRequestModel?.data?.length,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return CustomerRideRequestCardWidget(rideRequest: rideController.pendingRideRequestModel!.data![index], fromList: true, index: index);
                        },
                      ),
                    ),
                  ) :
                  const NoDataWidget():
                  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)),
                ),
              ),
            ]);
          }
        ),

      ),
    );
  }
}
