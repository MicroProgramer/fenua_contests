import 'package:fenua_contests/controllers/controller_ads.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/models/ticket.dart';
import 'package:fenua_contests/views/ads/ad_video_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/controller_custom_ads.dart';

class WalletScreen extends StatelessWidget implements RewardListener{
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.find<HomeScreenController>();
    // AdsController adsController = Get.put(AdsController(rewardListener: this, interstitialListener: this));
    // adsController.loadRewardAd();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var adsController = Get.put(ControllerCustomAds(rewardListener: this));
    Future.delayed(Duration(seconds: 1), (){
      adsController.loadAd(context);
    });

    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text(LocaleKeys.Tickets.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                LocaleKeys.YouHave.tr,
                style: heading1_style.copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_giftcard,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Hero(
                    tag: "wallet",
                    child: Obx(() {
                      return Text(
                        controller.myTickets.length.toString(),
                        style: TextStyle(fontSize: Get.height * 0.1, color: Colors.white, fontFamily: "JustBubble"),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                LocaleKeys.Tickets.tr,
                style: heading1_style.copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  LocaleKeys.morechance.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Divider(
                height: 50,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              Text(
                LocaleKeys.WinMoreTickets.tr,
                style: normal_h1Style_bold.copyWith(color: Colors.white),
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.InviteFriends.tr,
                          style: normal_h1Style_bold.copyWith(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/invite.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            LocaleKeys.GetTicketsForInvite.tr,
                            style: normal_h1Style_bold.copyWith(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            uid,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            LocaleKeys.YouReferCode.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              // await Clipboard.setData(ClipboardData(text: uid));
                              // Get.snackbar(LocaleKeys.Success, LocaleKeys.ReferCodeCopied.tr);
                            },
                            icon: Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // String url =
                            //     GetPlatform.isAndroid ? "https://play.google.com/store/apps/details?id=com.microprogramers.jeux.concours.fenua" : "https://apps.apple.com/us/app/jeux-concours-fenua/id1613685423";
                            // Share.share('$appName \n$url', subject: appName);
                          },
                          child: Text(
                            LocaleKeys.InviteNow.tr,
                            style: normal_h2Style_bold.copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            primary: appPrimaryColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   child: Container(
                  //     padding: EdgeInsets.all(15),
                  //     margin: EdgeInsets.all(30),
                  //     decoration: BoxDecoration(
                  //         color: appPrimaryColor, borderRadius: BorderRadius.circular(15), border: Border.all(width: 3, color: Colors.white)),
                  //     child: Text(
                  //       "Coming Soon",
                  //       style: normal_h2Style_bold.copyWith(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white)),
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.WatchVideoAds.tr,
                      style: normal_h1Style_bold.copyWith(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/watch_ads.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        LocaleKeys.GetTicket.tr,
                        style: normal_h1Style_bold.copyWith(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        LocaleKeys.Clickthebuttonbelowtowatchvideoadandearnmoretickets.tr,
                        style: normal_h3Style.copyWith(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (adsController.videoInitialized){
                          adsController.showRewardAd(context);
                        } else {
                          Get.snackbar("Alert", "Video not loaded yet, try again later");
                        }
                      },
                      child: Text(
                        LocaleKeys.WatchVideoAds.tr,
                        style: normal_h2Style_bold.copyWith(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        primary: appPrimaryColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onRewarded() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    usersRef
        .doc(uid)
        .collection("tickets")
        .doc(timestamp.toString())
        .set(Ticket(id: timestamp.toString(), timestamp: timestamp, user_id: uid).toMap())
        .then((value) {
      Get.snackbar("Congrats", LocaleKeys.Congrats1ticketaddedforyou.tr);
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
  }

  @override
  void onInterstitialClose() {
    // TODO: implement onInterstitialClose
  }

  @override
  void onInterstitialFailed() {
    // TODO: implement onInterstitialFailed
  }
}
