import 'package:fenua_contests/controllers/controller_ads.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/ticket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget implements RewardListener, InterstitialListener {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.find<HomeScreenController>();
    AdsController adsController = Get.put(AdsController(rewardListener: this,
      interstitialListener: this
    ));
    adsController.loadRewardAd();


    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text("Wallet"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/wallet.png",
                height: Get.height * 0.2,
              ),
              SizedBox(
                height: 20,
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
                        style: TextStyle(
                            fontSize: Get.height * 0.1,
                            color: Colors.white,
                            fontFamily: "JustBubble"),
                      );
                    }),
                  ),
                ],
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
              TextButton(

                onPressed: () {
                  Get.defaultDialog(
                      title: LocaleKeys.Winmoretickets.tr,
                      middleText:
                          LocaleKeys.Clickthebuttonbelowtowatchvideoadandearnmoretickets.tr,
                      confirmTextColor: Colors.white,
                      textConfirm: LocaleKeys.Earnticket.tr,
                      onConfirm: () {
                        Get.back();
                        adsController.showRewardAd();
                      });
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  primary: appPrimaryColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                ),
                child: Text(LocaleKeys.Winmoretickets.tr,
                    style: Theme.of(context).textTheme.headlineSmall!.merge(
                        TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
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
        .set(
            Ticket(id: timestamp.toString(), timestamp: timestamp, user_id: uid)
                .toMap())
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
