import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/splash_controller.dart';
import 'package:ride_sharing_user_app/features/trip/screens/image_video_viewer.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelProofImageView extends StatefulWidget {
  final List<String> proofImages;
  final bool isPickupProofImage;
  const ParcelProofImageView({super.key, required this.proofImages, required this.isPickupProofImage});

  @override
  State<ParcelProofImageView> createState() => _ParcelProofImageViewState();
}

class _ParcelProofImageViewState extends State<ParcelProofImageView> {
  String? baseUrl = '';
  List<Attachments>? attachments;

  @override
  void initState() {
    attachments = [];
    baseUrl = widget.isPickupProofImage ?
    Get.find<SplashController>().config?.imageBaseUrl?.parcelPickupProof :
    Get.find<SplashController>().config?.imageBaseUrl?.parcelDeliveryProof;

    widget.proofImages.forEach((image){
      attachments?.add(Attachments(file: '$baseUrl/$image'));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.isPickupProofImage ? 'pickup_image'.tr : 'completed_image'.tr, style: textSemiBold),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(height: 60,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.proofImages.length,
                separatorBuilder: (context, idx){
                  return SizedBox(width: Dimensions.paddingSizeSmall);
                },
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: ()=> Get.to(()=> ImageVideoViewer(attachments: attachments, clickedIndex: index, fromNetwork: true)),
                    child: ImageWidget(
                      image: '$baseUrl/${widget.proofImages[index]}',
                      height: 60, width: 60, radius: Dimensions.paddingSizeSmall,
                    ),
                  );
                }
            ),
          )
        ]),
      ),
    );
  }
}
