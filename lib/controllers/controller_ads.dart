import 'package:admob_flutter/admob_flutter.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:get/get.dart';

class AdsController extends GetxController {
  late AdmobReward rewardAd;
  RewardListener rewardListener;
  InterstitialListener interstitialListener;
  late AdmobInterstitial interstitialAd;
  var bannerLoaded = false.obs;
  AdmobBannerSize? _bannerSize;
  AdmobBanner? bannerAd;

  AdsController({
    required this.rewardListener,
    required this.interstitialListener,
  });

  @override
  void onInit() {
    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) {
          interstitialListener.onInterstitialClose();
        } else if (event == AdmobAdEvent.failedToLoad) {
          interstitialListener.onInterstitialFailed();
        }
      },
    );
    _bannerSize = AdmobBannerSize.BANNER;

    bannerAd = AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: _bannerSize!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        handleEvent(event, args, 'Banner');
      },
      onBannerCreated: (AdmobBannerController controller) {
        // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
        // Normally you don't need to worry about disposing this yourself, it's handled.
        // If you need direct access to dispose, this is your guy!
        // controller.dispose();
      },
    );

    super.onInit();
  }

  Future<void> loadRewardAd() async {
    await Admob.requestTrackingAuthorization();
    rewardAd.load();
  }

  Future<void> loadInterstitialAd() async {
    await Admob.requestTrackingAuthorization();
    interstitialAd.load();
  }

  AdmobBanner? getAdmobBanner() {
    return bannerAd;
  }

  @override
  void onClose() {
    rewardAd.dispose();
    interstitialAd.dispose();
    super.onClose();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        if (adType == "Banner") {
          bannerLoaded.value = true;
        }
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        break;
      case AdmobAdEvent.rewarded:
        print("reward");
        rewardListener.onRewarded();

        break;
      case AdmobAdEvent.failedToLoad:
        if (adType == "Banner") {
          bannerLoaded.value = false;
        }
        break;
      default:
    }
  }


  Future<void> showRewardAd() async {
    if (await rewardAd.isLoaded) {
      rewardAd.show();
    } else {
      rewardAd.load();
      Get.snackbar("Loading video ad", "Try again after 5 seconds");
    }
  }

  Future<String> showInterstitialAd() async {
    final isLoaded = await interstitialAd.isLoaded;
    if (isLoaded ?? false) {
      interstitialAd.show();
      return "success";
    }
    return "failed";
  }


  String getRewardBasedVideoAdUnitId() {
    String realIos = 'ca-app-pub-9499686178576729/5415338007';
    String realAndroid = 'ca-app-pub-9499686178576729/4249595996';
    String testIos = 'ca-app-pub-3940256099942544/1712485313';
    String testAndroid = 'ca-app-pub-3940256099942544/5224354917';

    if (GetPlatform.isIOS) {
      return realIos;
    } else if (GetPlatform.isAndroid) {
      return realAndroid;
    }
    return "";
  }

  String getBannerAdUnitId() {
    String realIos = "ca-app-pub-9499686178576729/5116234348";
    String realAndroid = "ca-app-pub-9499686178576729/3243915329";

    String testIos = "ca-app-pub-3940256099942544/2934735716";
    String testAndroid = "ca-app-pub-3940256099942544/6300978111";

    if (GetPlatform.isIOS) {
      return realIos;
    } else if (GetPlatform.isAndroid) {
      return realAndroid;
    }
    return "";
  }

  String getInterstitialAdUnitId() {
    String testIos = "ca-app-pub-3940256099942544/4411468910";
    String testAndroid = "ca-app-pub-3940256099942544/1033173712";

    String realIos = "ca-app-pub-9499686178576729/8863907664";
    String realAndroid = "ca-app-pub-9499686178576729/2298499318";

    if (GetPlatform.isIOS) {
      return realIos;
    } else if (GetPlatform.isAndroid) {
      return realAndroid;
    }
    return "";
  }
}
