import 'package:carousel_slider/carousel_slider.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_participant_public.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestDetailsScreen extends StatelessWidget {
  String contest_id;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Obx(() {
      Contest contest = controller.getContestById(contest_id)!;
      Organizer organizer = controller.getOrganizerById(contest.organizer_id)!;

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
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
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
                                  image: NetworkImage(
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
                                image: NetworkImage(organizer.image_url))),
                      ),
                      title: Text(
                        "Organized by",
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
                            "End of contest",
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
                        onTap: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: appSecondaryColorDark,
                        title: Text(
                          "Game Rules",
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
                                                  child: /*Icon(
                                              Icons.horizontal_rule_rounded,
                                              color: Colors.white54,
                                              size: 100,
                                            ),*/
                                                      Text(
                                                "20 Participants",
                                                style: heading3_style,
                                              )),
                                              // backgroundColor: appPrimaryColor,
                                              elevation: 2,
                                              automaticallyImplyLeading:
                                                  false, // remove back button in appbar.
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    controller:
                                                        scrollController,
                                                    itemCount: 20,
                                                    itemBuilder: (_, index) {
                                                      return ParticipantPublicItem(
                                                          user: controller
                                                              .usersList[0]);
                                                    }))
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
                          title: Text(
                            "Participants",
                            style: normal_h2Style_bold,
                          ),
                          trailing: Icon(
                            Icons.navigate_next,
                            color: appTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: Get.width,
                    color: appSecondaryColor,
                    child: CustomButton(
                      color: appPrimaryColor,
                      width: Get.width * 0.7,
                      child: Text(
                        "Extra Chances".toUpperCase(),
                        style: normal_h2Style_bold,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  ContestDetailsScreen({
    required this.contest_id,
  });
}
