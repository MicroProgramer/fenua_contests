import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:fenua_contests/views/ads/ad_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../interfaces/ads_listener.dart';

class ControllerCustomAds extends GetxController {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController customVideoPlayerController;
  bool videoInitialized = false;

  RewardListener rewardListener;

  ControllerCustomAds({
    required this.rewardListener,
  });

  void loadAd(BuildContext context) {
    String videoUrl =
        "https://firebasestorage.googleapis.com/v0/b/jeux-concours-fenua.appspot.com/o/Ads%2Fy2mate.com%20-%20A%20Great%20Example%20For%20A%2030%20Seconds%20B2B%20Explainer%20Video_1080p.mp4?alt=media&token=b43b965d-d006-4194-9a42-b94eb6322793";
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) {
        videoInitialized = true;
      });
    customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

  }

  Future<void> showRewardAd(BuildContext context) async {
    var result = await Get.to(AdVideoScreen(
      listener: rewardListener,
      videoPlayerController: this.videoPlayerController,
    ));
    videoInitialized = false;
    videoPlayerController.dispose();
    customVideoPlayerController.dispose();
    loadAd(context);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // if (videoPlayerController != null && customVideoPlayerController != null){
    //
      videoPlayerController.dispose();
      customVideoPlayerController.dispose();
    // }
    super.onClose();
  }
}
