import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/ad.dart';
import 'package:fenua_contests/views/ads/ad_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../interfaces/ads_listener.dart';

class ControllerCustomAds extends GetxController {
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? customVideoPlayerController;
  bool videoInitialized = false;
  final imageAds = List<Ad>.empty(growable: true).obs;
  final videoAds = List<Ad>.empty(growable: true).obs;

  RewardListener rewardListener;

  Ad? randomAd;

  ControllerCustomAds({
    required this.rewardListener,
  });

  void loadAd(BuildContext context) async {
    // String videoUrl =
    //     "https://firebasestorage.googleapis.com/v0/b/jeux-concours-fenua.appspot.com/o/Ads%2Fy2mate.com%20-%20A%20Great%20Example%20For%20A%2030%20Seconds%20B2B%20Explainer%20Video_1080p.mp4?alt=media&token=b43b965d-d006-4194-9a42-b94eb6322793";
    print(videoAds);
    randomAd = (videoAds..shuffle()).first;
    String videoUrl = randomAd!.mediaUrl;
    videoPlayerController = await VideoPlayerController.network(videoUrl)
      ..initialize().then((value) {
        videoInitialized = true;
      });
    customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController!,
    );
  }

  Future<void> showRewardAd(BuildContext context) async {
    if (randomAd != null){
      var result = await Get.to(AdVideoScreen(
        listener: rewardListener,
        ad: randomAd!,
        videoPlayerController: this.videoPlayerController!,
      ));
    } else {
      Get.snackbar("Alert", "Ad not loaded yet, please wait...");
    }
    videoInitialized = false;
    videoPlayerController!.dispose();
    customVideoPlayerController!.dispose();
    loadAd(context);
  }

  @override
  void onInit() {
    imageAds.bindStream(imageAdsStream());
    videoAds.bindStream(videoAdsStream());
    super.onInit();
  }

  @override
  void onClose() {
    // if (videoPlayerController != null && customVideoPlayerController != null){
    //
      if (videoPlayerController != null){
        videoPlayerController!.dispose();
        customVideoPlayerController!.dispose();
      }
    // }
    super.onClose();
  }

  Stream<List<Ad>> imageAdsStream() {
    Stream<QuerySnapshot> stream = adsRef.
    where("adType", isEqualTo: "image")
        .snapshots();

    return stream.map((querySnapshot) =>
        querySnapshot.docs
            .map((doc) =>
            Ad.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Ad>> videoAdsStream() {
    Stream<QuerySnapshot> stream = adsRef.
    where("adType", isEqualTo: "video")
        .snapshots();

    return stream.map((querySnapshot) =>
        querySnapshot.docs
            .map((doc) =>
            Ad.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }


}
