import 'package:admob_flutter/admob_flutter.dart';
import 'package:fenua_contests/helpers/reward_listener.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';

class AdsController extends GetxController{

  late AdmobReward rewardAd;
  RewardListener listener;
  AdsController(this.listener);

  @override
  void onInit() {
    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );
    rewardAd.load();
    super.onInit();
  }

  @override
  void onClose() {
    rewardAd.dispose();
    super.onClose();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:

        break;
      case AdmobAdEvent.opened:

        break;
      case AdmobAdEvent.closed:
        rewardAd.load();
        break;
      case AdmobAdEvent.failedToLoad:

        break;
      case AdmobAdEvent.rewarded:
        listener.onRewarded();

        break;
      default:
    }
  }

  String? getRewardBasedVideoAdUnitId() {
    if (GetPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (GetPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }

  Future<void> showRewardAd() async {
    Get.snackbar("Please Wait", "Loading video ad");
    if (await rewardAd.isLoaded){
      rewardAd.show();
    }
  }
}