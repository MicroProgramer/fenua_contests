import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/controllers/controller_custom_ads.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:fenua_contests/models/ticket.dart';
import 'package:fenua_contests/models/user_info.dart' as model;
import 'package:fenua_contests/views/ads/ad_video_screen.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_participant_public.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestDetailsScreen extends StatelessWidget implements RewardListener {
  String contest_id;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller = Get.find<AdminHomeScreenController>();
    Contest contest1 = controller.getContestById(contest_id);
    controller.getParticipants(contest_id, contest1.minimum_tickets);
    HomeScreenController homeScreenController = Get.find<HomeScreenController>();

    return Obx(() {
      Contest contest = controller.getContestById(contest_id);
      bool contestExpired = contest.end_timestamp < DateTime.now().millisecondsSinceEpoch;

      // ControllerCustomAds adsController = Get.put(ControllerCustomAds(rewardListener: this));
      // if (!contestExpired) {
      //   adsController.loadRewardAd();
      // }

      Organizer organizer = controller.getOrganizerById(contest.organizer_id);
      return Scaffold(
        backgroundColor: appSecondaryColor,
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            child: Text(contest.name),
            onLongPress: () {
              homeScreenController.addTicketsToMyAccount(500);
            },
          ),
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
                              image: DecorationImage(fit: BoxFit.fitHeight, image: CachedNetworkImageProvider(contest.images[itemIndex].toString()))),
                        );
                      },
                      options: CarouselOptions(
                          disableCenter: true,
                          enableInfiniteScroll: false,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          height: Get.height * (GetPlatform.isWeb ? 0.5 : 0.25)),
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
                          style: TextStyle(color: appTextColor, fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          String url = "";
                          for (var organizer in controller.organizersList) {
                            if (organizer.id == contest.organizer_id) {
                              url = organizer.website;
                            }
                          }
                          launchUrl(url);
                        },
                        child: Container(
                          height: Get.height * .05,
                          width: Get.width * .12,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: CachedNetworkImageProvider(
                                    organizer.image_url,
                                  ))),
                        ),
                      ),
                      title: Text(
                        LocaleKeys.Organizedby.tr,
                        style: normal_h3Style_bold.merge(TextStyle(color: Colors.black)),
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
                            style: normal_h3Style_bold.merge(TextStyle(color: Colors.black)),
                          ),
                          Text(
                            timestampToDateFormat(contest.end_timestamp, "EEE, dd/MM"),
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
                          launchUrl(Get.find<AdminHomeScreenController>().links!.game_rules);
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                            ShapeBorder shape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)));

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
                                    builder: (BuildContext context, ScrollController scrollController) {
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
                                              automaticallyImplyLeading: false, // remove back button in appbar.
                                            ),
                                            controller.participantsMap.length > 0
                                                ? Expanded(
                                                    child: ListView.builder(
                                                        controller: scrollController,
                                                        itemCount: controller.participantsMap.length,
                                                        itemBuilder: (_, index) {
                                                          String uid = controller.participantsMap.keys.elementAt(index).trim();
                                                          model.UserInfo user = controller.getUserById(uid);
                                                          return ParticipantPublicItem(
                                                            tickets:
                                                                controller.participantsMap[uid] == null ? 0 : controller.participantsMap[uid]!.length,
                                                            user: user,
                                                            minTickets: contest.minimum_tickets,
                                                            winner: user.id == contest.winner_id,
                                                          );
                                                        }),
                                                  )
                                                : NotFound(color: Colors.white70, message: "No Participants")
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // have border decoration
                        child: Stack(
                          // you may need to wrap with sizedBOx
                          children: [
                            SizedBox(
                              height: Get.height * .05,
                              //stack size, or use fit
                              width: Get.width * .8,
                              child: LinearProgressIndicator(
                                value: (int.parse(_calculateInvestedTickets(controller)) < contest.minimum_tickets)
                                    ? (int.parse(_calculateInvestedTickets(controller)) / contest.minimum_tickets)
                                    : 1,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _getProgressColor(int.parse(_calculateInvestedTickets(controller)) / contest.minimum_tickets)),
                              ),
                            )
                            //place your widget
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (contest.minimum_tickets - int.parse(_calculateInvestedTickets(controller)) >= 1)
                            ? ("${contest.minimum_tickets - int.parse(_calculateInvestedTickets(controller))} " + LocaleKeys.TicketsRequired.tr)
                            : LocaleKeys.YouAreAPartOfContest.tr,
                        style: normal_h3Style.copyWith(color: hintColor).merge(TextStyle(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        LocaleKeys.Youinvestedtickets.tr.replaceAll("1", "${_calculateInvestedTickets(controller)}"),
                        style: normal_h3Style_bold.merge(TextStyle(color: Colors.black)),
                      ),
                    ),
                    CustomButton(
                      color: appPrimaryColor,
                      width: Get.width * 0.7,
                      child: Text(
                        "${contestExpired ? LocaleKeys.Expired.tr : LocaleKeys.EXTRACHANCES.tr}".toUpperCase(),
                        style: normal_h2Style_bold,
                      ),
                      onPressed: () async {
                        if (contestExpired) {
                          Get.snackbar(LocaleKeys.Sorry.tr, LocaleKeys.ContestHasBeenExpired.tr,
                              colorText: Colors.white, backgroundColor: Colors.black);
                          return;
                        }
                        if (homeScreenController.myTickets.length > 0) {
                          Get.defaultDialog(
                              title: LocaleKeys.Useaccountticket.tr,
                              middleText: LocaleKeys.Youalreadyhaveinyouraccountbalance.tr
                                  .toString()
                                  .replaceAll("1", "${homeScreenController.myTickets.length}"),
                              onConfirm: () async {
                                Get.back();

                                if (homeScreenController.myTickets.length == 1) {
                                  await homeScreenController.deleteTicketsAndInvest(contest_id, 1);
                                  return;
                                }

                                String num = "";
                                Get.defaultDialog(
                                    title: LocaleKeys.InvestMultipleTickets.tr,
                                    content: CustomInputField(
                                      hint: "max. ${homeScreenController.myTickets.length}",
                                      isPasswordField: false,
                                      keyboardType: TextInputType.number,
                                      onChange: (value) {
                                        num = value.toString();
                                      },
                                    ),
                                    textConfirm: LocaleKeys.Invest.tr,
                                    confirmTextColor: Colors.white,
                                    textCancel: LocaleKeys.Cancel.tr,
                                    onCancel: () {
                                      Get.back();
                                    },
                                    onConfirm: () async {
                                      Get.back();
                                      if (!num.isNum) {
                                        Get.snackbar(LocaleKeys.Alert.tr, LocaleKeys.InvalidValue.tr);
                                        return;
                                      }
                                      await homeScreenController.deleteTicketsAndInvest(contest_id, int.parse(num));
                                    });
                              },
                              onCancel: () async {
                                var result = await Get.to(AdVideoScreen(listener: this));
                                print(result);
                              },
                              textCancel: LocaleKeys.WatchAdanyway.tr,
                              textConfirm: LocaleKeys.Useaccountticket.tr,
                              confirmTextColor: Colors.white);
                        } else {
                          var result = await Get.to(AdVideoScreen(listener: this));
                          print(result);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
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
        .set(Ticket(id: "$timestamp", timestamp: timestamp, user_id: FirebaseAuth.instance.currentUser!.uid).toMap())
        .then((value) => Get.snackbar("Congrats", "1 ticket added for you", colorText: Colors.white, backgroundColor: Colors.green));
  }

  String _calculateInvestedTickets(var controller) {
    return "${controller.participantsMap[FirebaseAuth.instance.currentUser!.uid] == null ? "0" : controller.participantsMap[FirebaseAuth.instance.currentUser!.uid]!.length}";
  }

  Color _getProgressColor(var progress) {
    if (progress <= .5) {
      return Colors.red;
    } else if (progress <= .8) {
      return appPrimaryColor;
    } else if (progress <= .93) {
      return Colors.greenAccent;
    } else {
      return Colors.green;
    }
  }
}
