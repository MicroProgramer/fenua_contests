import 'package:fenua_contests/views/ads/ad_video_screen.dart';
import 'package:get/get.dart';

import '../interfaces/ads_listener.dart';

class ControllerCustomAds extends GetxController {


  RewardListener rewardListener;
  Future<void> showRewardAd() async {
    await Get.to(AdVideoScreen(listener: rewardListener));
  }
  ControllerCustomAds({
    required this.rewardListener,
  });
}