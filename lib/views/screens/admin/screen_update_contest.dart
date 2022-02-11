import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../controllers/controller_update_contest.dart';

class UpdateContestScreen extends StatelessWidget {
  Contest contest;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UpdateContestController(), fenix: true);
    UpdateContestController controller = Get.find<UpdateContestController>();
    AdminHomeScreenController home_controller =
        Get.find<AdminHomeScreenController>();

    controller.startTimestamp.value = contest.start_timestamp;
    controller.endTimestamp.value = contest.end_timestamp;
    controller.updateDropdown(contest.organizer_id);
    controller.participantsCheck.value = contest.show_participants_info;
    controller.contest_id.value = contest.id;
    controller.images = contest.images.map((e) => e.toString()).toList();

    return Scaffold(
      backgroundColor: appSecondaryColor,
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text(contest.name),
      ),
      body: Obx(
        () {
          return ModalProgressHUD(
            inAsyncCall: controller.showLoading.value,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Contest Images",
                      style:
                          heading3_style.merge(TextStyle(color: Colors.black)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: Get.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        controller.images[0])),
                                boxShadow: [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                ]),
                          ),
                          onTap: () {
                            controller.pickImage(index: 0);
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: Get.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        controller.images[1])),
                                boxShadow: [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                ]),
                          ),
                          onTap: () {
                            controller.pickImage(index: 1);
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: Get.height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        controller.images[2])),
                                boxShadow: [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                ]),
                          ),
                          onTap: () {
                            controller.pickImage(index: 2);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Contest Details",
                      style: heading3_style,
                    ),
                  ),
                  CustomInputField(
                      hint: "Title",
                      text: contest.name,
                      isPasswordField: false,
                      fillColor: Colors.white,
                      controller: controller.title_controller.value,
                      keyboardType: TextInputType.name),
                  CustomInputField(
                      hint: "Description",
                      text: contest.description,
                      isPasswordField: false,
                      fillColor: Colors.white,
                      maxLines: 3,
                      controller: controller.description_controller.value,
                      keyboardType: TextInputType.multiline),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Organizer",
                      style: heading3_style,
                    ),
                  ),
                  DropdownButton<String>(
                    value: contest.organizer_id,
                    items: home_controller.organizersList
                        .map((organizer) => DropdownMenuItem<String>(
                            value: organizer.id,
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.network(
                                    organizer.image_url,
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(organizer.name),
                                ],
                              ),
                            )))
                        .toList(),
                    onChanged: (value) {
                      controller.updateDropdown(value.toString());
                    },
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.white,
                          onTap: () async {
                            DateTime selectedDate = await selectDate(
                                context,
                                DateTime.now().millisecondsSinceEpoch,
                                controller.startTimestamp.value);
                            controller.updateStartDate(selectedDate);
                          },
                          title: RichText(
                              text: TextSpan(
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  children: [
                                TextSpan(text: "Starting from "),
                                TextSpan(
                                    text: timestampToDateFormat(
                                        controller.startTimestamp.value,
                                        "dd MMM, yyyy"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ])),
                          leading: Icon(Icons.access_time),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.white,
                          onTap: () async {
                            DateTime start =
                                DateTime.fromMillisecondsSinceEpoch(
                                    controller.startTimestamp.value);
                            DateTime selectedDate = await selectDate(
                                context,
                                DateTime(start.year, start.month, start.day + 1)
                                    .millisecondsSinceEpoch,
                                null);
                            controller.updateEndDate(selectedDate);
                          },
                          title: RichText(
                              text: TextSpan(
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  children: [
                                TextSpan(text: "Ending at "),
                                TextSpan(
                                    text: timestampToDateFormat(
                                        controller.endTimestamp.value,
                                        "dd MMM, yyyy"),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ])),
                          leading: Icon(Icons.access_time),
                        ),
                      ),
                      SwitchListTile.adaptive(
                          title: Text(
                            "Show participants to users",
                            style: heading4_style,
                          ),
                          value: controller.participantsCheck.value,
                          onChanged: (newVal) {
                            controller.updateParticipantsCheck(newVal);
                          }),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomButton(
                            color: appPrimaryColor,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () async {
                              String response =
                                  await controller.updateContest(contest.id);
                              if (response.isEmpty) {
                                _showSnack("Something went wrong");
                              } else if (response == "success") {
                                showSnackBar("Contest Updated", context);
                                Get.back(closeOverlays: true);
                              } else {
                                _showSnack(response);
                              }
                            }),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnack(String message) {
    Get.snackbar("Alert", message,
        colorText: Colors.white, backgroundColor: Colors.black);
  }

  UpdateContestScreen({required this.contest});
}
