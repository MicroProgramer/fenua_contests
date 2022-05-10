import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/interfaces/home_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controller_admin_home_screen.dart';
import '../../../helpers/constants.dart';
import '../../../models/contest.dart';

class ContestItem extends StatelessWidget {
  double containerHeight = Get.height /** (GetPlatform.isWeb ? 2 : 1)*/ * 0.35;
  Contest contest;
  AdminHomeScreenController controller;
  ContestItemListener contestItemListener;

  @override
  Widget build(BuildContext context) {
    bool contestExpired =
        contest.end_timestamp < DateTime.now().millisecondsSinceEpoch ||
            contest.winner_id.isNotEmpty;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: containerHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: CachedNetworkImageProvider(contest.images[0])),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white)]),
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Visibility(
            visible: contest.winner_id.isNotEmpty,
            child: Positioned(
                left: 2,
                top: 0,
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
                                      .getUserById(contest.winner_id)
                                      .first_name +
                                  " " +
                                  controller
                                      .getUserById(contest.winner_id)
                                      .last_name
                              : "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
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
                      (!contestExpired)
                          ? (contest.start_timestamp >
                                  DateTime.now().millisecondsSinceEpoch
                              ? convertTimeToText(
                                  "Starting in", contest.start_timestamp, "")
                              : convertTimeToText(
                                  "", contest.end_timestamp, "left"))
                          : LocaleKeys.Expired.tr,
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
                      height: containerHeight * .20,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            contestItemListener.onItemOpen(
                                contest_id: contest.id);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: appPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(contestExpired
                              ? LocaleKeys.Open.tr
                              : LocaleKeys.Participate.tr),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Positioned(
                    child: GestureDetector(
                      onTap: () {
                        try {
                          launchUrl(getOrganizerWebsite(contest.organizer_id));
                        } catch(e){}
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    getOrganizerImage(contest.organizer_id)))),
                        height: containerHeight * .3,
                        width: containerHeight * .3,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ContestItem(
      {required this.contest,
      required this.controller,
      required this.contestItemListener});

  String getOrganizerImage(String id) {
    for (var organizer in controller.organizersList) {
      if (organizer.id == id) {
        return organizer.image_url;
      }
    }
    return "";
  }

  String getOrganizerWebsite(String id) {
    for (var organizer in controller.organizersList) {
      if (organizer.id == id) {
        return organizer.website;
      }
    }
    return "";
  }
}
