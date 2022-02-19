import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/controllers/controller_ads.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:fenua_contests/models/ticket.dart';
import 'package:fenua_contests/models/user_info.dart' as model;
import 'package:fenua_contests/views/layouts/item_layouts/item_participant_public.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestDetailsScreen extends StatelessWidget
    implements RewardListener, InterstitialListener {
  String contest_id;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.put(AdminHomeScreenController(), tag: contest_id);
    controller.getParticipants(contest_id);
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();

    return Obx(() {
      Contest contest = controller.getContestById(contest_id);
      bool contestExpired =
          contest.end_timestamp < DateTime.now().millisecondsSinceEpoch;

      AdsController adsController = Get.put(
          AdsController(rewardListener: this, interstitialListener: this),
          tag: contest_id);
      if (!contestExpired) {
        adsController.loadRewardAd();
      }

      Organizer organizer = controller.getOrganizerById(contest.organizer_id);
      return Scaffold(
        backgroundColor: appSecondaryColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(contest.name),
          backgroundColor: appSecondaryColor,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(Icons.share),
          //   ),
          // ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: contest.images.length,
                      itemBuilder: (_, itemIndex, pageViewIndex) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: appPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                      contest.images[itemIndex].toString()))),
                        );
                      },
                      options: CarouselOptions(
                          disableCenter: true,
                          enableInfiniteScroll: false,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          height: Get.height * 0.25),
                    ),
                    Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20),
                      height: Get.height * .1,
                      color: appSecondaryColorDark,
                      child: Hero(
                        tag: "contest_name",
                        child: Text(
                          contest.name,
                          style: TextStyle(
                              color: appTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        height: Get.height * .05,
                        width: Get.width * .12,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                  organizer.image_url,
                                ))),
                      ),
                      title: Text(
                        LocaleKeys.Organizedby.tr,
                        style: normal_h3Style_bold
                            .merge(TextStyle(color: Colors.black)),
                      ),
                      subtitle: Text(
                        organizer.name,
                        style: normal_h4Style_bold,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.Endofcontest.tr,
                            style: normal_h3Style_bold
                                .merge(TextStyle(color: Colors.black)),
                          ),
                          Text(
                            timestampToDateFormat(
                                contest.end_timestamp, "EEE, dd/MM"),
                            style: normal_h4Style_bold,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: GetPlatform.isIOS,
                      child: ListTile(
                        tileColor: appPrimaryColor,
                        leading: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Apple n’est pas un sponsor et n’est en aucun cas en partenariat avec notre application ou notre système de concours, loteries ou tirage au sort.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        contest.description,
                        style: normal_h3Style,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          launchUrl(Get.find<AdminHomeScreenController>()
                              .links!
                              .game_rules);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: appSecondaryColorDark,
                        title: Text(
                          LocaleKeys.GameRules.tr,
                          style: normal_h2Style_bold,
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: appTextColor,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: contest.show_participants_info,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            ShapeBorder shape = RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10.0)));

                            showModalBottomSheet<dynamic>(
                                isScrollControlled: true,
                                context: context,
                                shape: shape,
                                enableDrag: true,
                                backgroundColor: appPrimaryColor,
                                builder: (context) {
                                  return DraggableScrollableSheet(
                                    maxChildSize: 0.8,
                                    expand: false,
                                    builder: (BuildContext context,
                                        ScrollController scrollController) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            AppBar(
                                              shape: shape,
                                              centerTitle: true,
                                              actions: [
                                                IconButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Icon(Icons.close))
                                              ],
                                              title: Container(
                                                  child: Text(
                                                "${controller.participantsMap.length} ${LocaleKeys.Participants.tr}",
                                                style: heading3_style,
                                              )),
                                              // backgroundColor: appPrimaryColor,
                                              elevation: 2,
                                              automaticallyImplyLeading:
                                                  false, // remove back button in appbar.
                                            ),
                                            controller.participantsMap.length >
                                                    0
                                                ? Expanded(
                                                    child: ListView.builder(
                                                        controller:
                                                            scrollController,
                                                        itemCount: controller
                                                            .participantsMap
                                                            .length,
                                                        itemBuilder:
                                                            (_, index) {
                                                          String uid = controller
                                                              .participantsMap
                                                              .keys
                                                              .elementAt(index)
                                                              .trim();
                                                          model.UserInfo user =
                                                              controller
                                                                  .getUserById(
                                                                      uid);
                                                          return ParticipantPublicItem(
                                                            tickets: controller
                                                                            .participantsMap[
                                                                        uid] ==
                                                                    null
                                                                ? 0
                                                                : controller
                                                                    .participantsMap[
                                                                        uid]!
                                                                    .length,
                                                            user: user,
                                                            winner: user.id ==
                                                                contest
                                                                    .winner_id,
                                                          );
                                                        }),
                                                  )
                                                : NotFound(
                                                    color: Colors.white70,
                                                    message: "No Participants")
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: appSecondaryColorDark,
                          title: Row(
                            children: [
                              Text(
                                LocaleKeys.Participants.tr,
                                style: normal_h2Style_bold,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "(${controller.participantsMap.length})",
                                style: normal_h1Style_bold,
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: appTextColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        LocaleKeys.Youinvestedtickets.tr.replaceAll("1",
                            "${controller.participantsMap[FirebaseAuth.instance.currentUser!.uid] == null ? "0" : controller.participantsMap[FirebaseAuth.instance.currentUser!.uid]!.length}"),
                        style: normal_h3Style_bold
                            .merge(TextStyle(color: Colors.black)),
                      ),
                    ),
                    CustomButton(
                      color: appPrimaryColor,
                      width: Get.width * 0.7,
                      child: Text(
                        "${contestExpired ? LocaleKeys.Expired.tr : LocaleKeys.EXTRACHANCES.tr}"
                            .toUpperCase(),
                        style: normal_h2Style_bold,
                      ),
                      onPressed: () {
                        if (contestExpired) {
                          Get.snackbar(LocaleKeys.Sorry.tr,
                              LocaleKeys.ContestHasBeenExpired.tr,
                              colorText: Colors.white,
                              backgroundColor: Colors.black);
                          return;
                        }
                        if (homeScreenController.myTickets.length > 0) {
                          Get.defaultDialog(
                              title: LocaleKeys.Useaccountticket.tr,
                              middleText: LocaleKeys
                                  .Youalreadyhaveinyouraccountbalance.tr
                                  .toString()
                                  .replaceAll("1",
                                      "${homeScreenController.myTickets.length}"),
                              onConfirm: () async {
                                Get.back();
                                Ticket ticket =
                                    homeScreenController.myTickets.value[0];
                                await homeScreenController
                                    .deleteTicket(ticket.id);
                                contestsRef
                                    .doc(contest_id)
                                    .collection("tickets")
                                    .doc("${ticket.id}")
                                    .set(ticket.toMap())
                                    .then(
                                      (value) => Get.snackbar(
                                          "Congrats",
                                          LocaleKeys
                                              .Congrats1ticketaddedforyou.tr),
                                    );
                              },
                              onCancel: () {
                                Get.back();
                                Get.find<AdsController>(tag: contest_id)
                                    .showRewardAd();
                              },
                              textCancel: LocaleKeys.WatchAdanyway.tr,
                              textConfirm: LocaleKeys.Useaccountticket.tr,
                              confirmTextColor: Colors.white);
                        } else {
                          Get.find<AdsController>(tag: contest_id)
                              .showRewardAd();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: Get.width,
                  color: appSecondaryColor,
                  child: adsController.bannerAd!),
            )
          ],
        ),
      );
    });
  }

  ContestDetailsScreen({
    required this.contest_id,
  });

  @override
  void onRewarded() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    contestsRef
        .doc(contest_id)
        .collection("tickets")
        .doc("$timestamp")
        .set(Ticket(
                id: "$timestamp",
                timestamp: timestamp,
                user_id: FirebaseAuth.instance.currentUser!.uid)
            .toMap())
        .then((value) => Get.snackbar("Congrats", "1 ticket added for you",
            colorText: Colors.white, backgroundColor: Colors.green));
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
