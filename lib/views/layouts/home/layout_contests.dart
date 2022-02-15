import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/controllers/controller_ads.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/interfaces/home_listener.dart';
import 'package:fenua_contests/views/screens/screen_contest_details.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../item_layouts/item_contest.dart';

class ContestsLayout extends StatelessWidget
    implements ContestItemListener, InterstitialListener, RewardListener {
  late String contestId;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    Get.put(AdsController(interstitialListener: this, rewardListener: this), tag: "homescreen").loadInterstitialAd();

    return Obx(() {
      return controller.contestsList.length > 0
          ? ListView.builder(
              itemCount: controller.contestsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContestItem(
                    controller: controller,
                    contest: controller.contestsList[index],
                    contestItemListener: this,
                  ),
                );
              })
          : NotFound(color: Colors.black87, message: "No Contests");
    });
  }

  @override
  void onItemOpen({required String contest_id}) async {
    print(contest_id);
    contestId = contest_id;
    String status = await Get.find<AdsController>(tag: "homescreen").showInterstitialAd();
    print(status);
    if (status != "success"){
      openDetailsScreen();
    }
  }

  void openDetailsScreen() {
    Get.to(ContestDetailsScreen(contest_id: contestId));
  }

  @override
  void onInterstitialClose() {
    print(contestId);
    openDetailsScreen();
  }

  @override
  void onInterstitialFailed() {
    openDetailsScreen();
  }

  @override
  void onRewarded() {
    // TODO: implement onRewarded
  }
}
