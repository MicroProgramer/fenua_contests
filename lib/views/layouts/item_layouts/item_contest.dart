import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/screens/screen_contest_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controller_admin_home_screen.dart';
import '../../../models/contest.dart';

class ContestItem extends StatelessWidget {


  double containerHeight = Get.height * 0.3;
  Contest contest;
  AdminHomeScreenController controller;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: containerHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(contest.images[0])
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.white)]),
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alarm),
                    SizedBox(
                      width: 5,
                    ),
                    Text("20 Days left"),
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ContestDetailsScreen(
                              contest_id: contest.id
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: appPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Participate"),
                        ),
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
                                image: NetworkImage(
                                    getOrganizerImage(contest.organizer_id)
                                ))),
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
  }

  ContestItem({
    required this.contest,
    required this.controller,
  });

  String getOrganizerImage(String id) {
    for (var organizer in controller
        .organizersList) {
      if (organizer.id == id) {
        return organizer.image_url;
      }
    }
    return "";
  }
}
