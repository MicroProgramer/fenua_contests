import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:fenua_contests/views/screens/admin/screen_update_contest.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../helpers/constants.dart';
import '../../../widgets/not_found.dart';
import 'item_participant_public.dart';

class ContestItemAdmin extends StatelessWidget {
  double containerHeight = Get.height * 0.35;
  Contest contest;
  AdminHomeScreenController controller_1;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.put(AdminHomeScreenController(), tag: contest.id);
    controller.getParticipants(contest.id, contest.minimum_tickets);

    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: containerHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(contest.images[0])),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.white)
            ]),
        margin: EdgeInsets.all(10),
        child: Stack(
          children: [
            Visibility(
              visible: contest.winner_id.isNotEmpty,
              child: Positioned(
                  left: 2,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      UserInfo winner =
                          controller.getUserById(contest.winner_id);

                      Get.defaultDialog(
                          title: "Copy ${winner.first_name}'s email",
                          content: Text(
                            winner.email,
                            style: normal_h2Style_bold.merge(
                                TextStyle(color: Colors.black)),
                          ),
                          textCancel: "Cancel",
                          textConfirm: "Copy Email",
                          confirmTextColor: Colors.white,
                          onCancel: () {
                            Get.back();
                          },
                          onConfirm: () async {
                            Get.back();
                            ClipboardData data =
                                ClipboardData(text: winner.email);
                            await Clipboard.setData(data);
                            Get.snackbar("Email Copied",
                                "Winner's email copied to clipboard");
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: Get.width * 0.35,
                            child: Text(
                              contest.winner_id.isNotEmpty
                                  ? controller
                                          .getUserById(
                                              contest.winner_id)
                                          .first_name +
                                      " " +
                                      controller
                                          .getUserById(
                                              contest.winner_id)
                                          .last_name
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFFE1E1E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.alarm),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (contest.end_timestamp >
                                    DateTime.now()
                                        .millisecondsSinceEpoch &&
                                contest.winner_id.isEmpty)
                            ? (contest.start_timestamp >
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                ? convertTimeToText("Starting in",
                                    contest.start_timestamp, "")
                                : convertTimeToText("",
                                    contest.end_timestamp, "left"))
                            : LocaleKeys.Expired.tr.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Color(0xD4121212),
                        height: containerHeight * 0.2,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                          contest.name,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                        child: Container(
                          color: appPrimaryColor,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        height: containerHeight * .25,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                                color: appPrimaryColor,
                                width: Get.width * 0.4,
                                height: Get.height * 0.05,
                                child: Text(
                                  "Participants (${controller.participantsMap.length})",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  ShapeBorder shape =
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.vertical(
                                                  top:
                                                      Radius.circular(
                                                          10.0)));

                                  showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      context: context,
                                      shape: shape,
                                      enableDrag: true,
                                      backgroundColor:
                                          appPrimaryColor,
                                      builder: (context) {
                                        return DraggableScrollableSheet(
                                          maxChildSize: 0.8,
                                          expand: false,
                                          builder: (BuildContext
                                                  context,
                                              ScrollController
                                                  scrollController) {
                                            return Container(
                                              child: Column(
                                                children: [
                                                  AppBar(
                                                    shape: shape,
                                                    centerTitle: true,
                                                    actions: [
                                                      Visibility(
                                                        visible: controller
                                                                    .acceptedParticipants >
                                                                0 &&
                                                            contest
                                                                .winner_id
                                                                .isEmpty,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Get.defaultDialog(
                                                                  title: "Withdraw Contest Prize",
                                                                  content: Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: Column(
                                                                      children: [
                                                                        Text("Are you sure to do the contest prize withdraw between"
                                                                            " ${controller.participantsMap.length} participants"),
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: 20),
                                                                          child: Stack(
                                                                            children: [
                                                                              Lottie.asset("assets/lottie/spinner.json", repeat: false),
                                                                              Align(alignment: Alignment.center, child: Image.asset("assets/images/logo_transparent.png"))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  textCancel: "Cancel",
                                                                  textConfirm: "Withdraw",
                                                                  confirmTextColor: Colors.white,
                                                                  onCancel: () {
                                                                    Get.back();
                                                                  },
                                                                  onConfirm: () {
                                                                    Get.back();
                                                                    controller.withdraw(contest.id, contest.minimum_tickets);
                                                                  });
                                                            },
                                                            tooltip: "Withdraw",
                                                            icon: Icon(Icons.volunteer_activism)),
                                                      ),
                                                    ],
                                                    title: Container(
                                                      child: /*Icon(
                                              Icons.horizontal_rule_rounded,
                                              color: Colors.white54,
                                              size: 100,
                                            ),*/
                                                          Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "(${controller.participantsMap.length})",
                                                            style:
                                                                heading3_style,
                                                          ),
                                                          Text(
                                                            "${controller.acceptedParticipants} Tickets",
                                                            style:
                                                                heading3_style,
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(Icons
                                                                  .local_movies_rounded),
                                                              SizedBox(width: 5,),
                                                              Text(contest
                                                                  .minimum_tickets
                                                                  .toString()),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    // backgroundColor: appPrimaryColor,
                                                    elevation: 2,
                                                    automaticallyImplyLeading:
                                                        false, // remove back button in appbar.
                                                  ),
                                                  Expanded(
                                                      child: controller
                                                                  .participantsMap
                                                                  .length >
                                                              0
                                                          ? ListView
                                                              .builder(
                                                                  controller:
                                                                      scrollController,
                                                                  itemCount: controller
                                                                      .participantsMap.length,
                                                                  itemBuilder: (_,
                                                                      index) {
                                                                    String uid = controller.participantsMap.keys.elementAt(index);
                                                                    UserInfo user = controller.getUserById(uid);
                                                                    return ParticipantPublicItem(
                                                                      tickets: controller.participantsMap[uid]!.length,
                                                                      user: user,
                                                                      minTickets: contest.minimum_tickets,
                                                                      winner: user.id == contest.winner_id,
                                                                    );
                                                                  })
                                                          : NotFound(
                                                              color: Colors
                                                                  .white70,
                                                              message:
                                                                  "No Participants"))
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                }),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => UpdateContestScreen(
                                      contest: contest));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: appPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10))),
                                child: Text("Edit"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    return Positioned(
                        child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  getOrganizerImage(
                                      contest.organizer_id)))),
                      height: containerHeight * .3,
                      width: containerHeight * .3,
                    ));
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String getOrganizerImage(String id) {
    for (var organizer in controller_1.organizersList) {
      if (organizer.id == id) {
        return organizer.image_url;
      }
    }
    return "";
  }

  ContestItemAdmin({
    required this.contest,
    required this.controller_1,
  });
}
