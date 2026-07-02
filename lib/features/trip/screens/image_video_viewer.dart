import 'dart:io';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:video_player/video_player.dart';


class ImageVideoViewer extends StatefulWidget {
  final int clickedIndex;
  final List<Attachments>? attachments;
  final List<XFile>? proofImages;
  final bool fromNetwork;
  const ImageVideoViewer({super.key,this.fromNetwork = false,this.attachments,this.proofImages,required this.clickedIndex});

  @override
  State<ImageVideoViewer> createState() => _ImageVideoViewerState();
}

class _ImageVideoViewerState extends State<ImageVideoViewer> {
  VideoPlayerController? controller;
  ChewieController? chewController;
  late PageController pageController;
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.clickedIndex;
    pageController = PageController(initialPage: widget.clickedIndex);
    _loadVideo();
    super.initState();
  }

  Future<void> _loadVideo() async {
    if (controller != null) {
      VideoPlayerController? oldController = controller;
      controller = null;
      await oldController?.dispose();
    }
    if (chewController != null) {
      chewController?.dispose();
      chewController = null;
    }

    String? path;
    if (widget.fromNetwork) {
      if (widget.attachments != null && widget.attachments!.length > currentIndex) {
        path = widget.attachments![currentIndex].file;
      }
    } else {
      if (widget.proofImages != null && widget.proofImages!.length > currentIndex) {
        path = widget.proofImages![currentIndex].path;
      }
    }

    if (path != null && path.contains('.mp4')) {
      if (widget.fromNetwork) {
        controller = VideoPlayerController.networkUrl(Uri.parse(path));
      } else {
        controller = VideoPlayerController.file(File(path));
      }

      if (controller != null) {
        chewController = ChewieController(
          videoPlayerController: controller!,
          autoPlay: true,
          looping: true,
          allowFullScreen: false,
          placeholder: Center(child: CircularProgressIndicator(color: Get.theme.primaryColor)),
        );
      }
    }
  }

  @override
  void dispose() {
    chewController?.dispose();
    controller?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index){
            String? path = widget.fromNetwork ?
            (widget.attachments != null && widget.attachments!.length > index ? widget.attachments![index].file : null) :
            (widget.proofImages != null && widget.proofImages!.length > index ? widget.proofImages![index].path : null);
            bool isVideo = path?.contains('.mp4') ?? false;

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row( children: [
                  Expanded(child: Text(
                    _extractFileName(path),
                    style: textRegular.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSeven),

                  InkWell(
                    onTap: ()=> Get.back(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(Images.crossIcon,height: 10,width: 10,color: Colors.white),
                    ),
                  )
                ]),
              ),
              SizedBox(height: Get.height * 0.01),

              isVideo ? Flexible(
                child: Center(child: (index == currentIndex && chewController != null) ?
                Chewie(controller: chewController!) :
                CircularProgressIndicator(color: Theme.of(context).primaryColor)),
              ) : Expanded(
                child: widget.fromNetwork ?
                ImageWidget(image: path ?? '') :
                Image.file(File(path ?? '')),
              ),

            ]);
          },
          itemCount: widget.fromNetwork ? widget.attachments?.length : widget.proofImages?.length,
          onPageChanged: (index) async{
            currentIndex = index;
            await _loadVideo();
            setState(() {});
          },
        ),
      ),
    );
  }

  String _extractFileName(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      List<String> segments = Uri.parse(url).pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      } else {
        return url.split('/').last;
      }
    } catch (e) {
      return url.split('/').last;
    }
  }

}
