import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_contest_admin.dart';
import 'package:fenua_contests/views/screens/admin/screen_add_new_contest.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestsAdminLayout extends StatelessWidget {
  const ContestsAdminLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    Widget _offsetPopup() => PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(
                "New Contest",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(
                "New Notification",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ],
          icon: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: ShapeDecoration(
                color: appPrimaryColor,
                shape: StadiumBorder(
                  side: BorderSide(color: appPrimaryColor, width: 1),
                ),
                shadows: [BoxShadow(blurRadius: 0.5)]),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          onSelected: (index) {
            String title = "";
            String des = "";
            switch (index) {
              case 0:
                Get.to(AddNewContestScreen());
                break;
              case 1:
                Get.defaultDialog(
                  title: "Notify Users",
                  content: Column(
                    children: [
                      CustomInputField(
                          hint: "Title",
                          isPasswordField: false,
                          onChange: (value) {
                            title = value.toString();
                          },
                          keyboardType: TextInputType.text),
                      CustomInputField(
                          hint: "Description",
                          isPasswordField: false,
                          onChange: (value) {
                            des = value.toString();
                          },
                          keyboardType: TextInputType.text),
                      CustomButton(
                        color: appPrimaryColor,
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          controller.notifyAllUsers(title, des).then((value) =>
                              Get.snackbar(
                                  "Success".tr, "Notification sent to all users",
                                  colorText: Colors.white,
                                  backgroundColor: Colors.green));
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
                break;
            }
          },
        );

    return Scaffold(
        backgroundColor: appSecondaryColor,
        floatingActionButton: Container(
            height: 80.0,
            width: 80.0,
            child:
                _offsetPopup()) /*FloatingActionButton(
          onPressed: () {
            if (controller.organizersList.length < 1) {
              Get.snackbar("Alert", "Must Add 1 organizer",
                  colorText: Colors.white, backgroundColor: Colors.black);
              return;
            }
            Get.to(AddNewContestScreen());
          },
          child: Icon(Icons.add),
        )*/
        ,
        body: Obx(() {
          return controller.liveContestsList.length > 0
              ? SingleChildScrollView(
            physics: ScrollPhysics(),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.liveContestsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ContestItemAdmin(
                                controller_1: controller,
                                contest: controller.liveContestsList[index],
                              ),
                            );
                          }),
                      Container(
                        color: Colors.transparent,
                        height: 100,
                      ),
                    ],
                  ),
              )
              : NotFound(color: Colors.black87, message: "NoContests".tr);
        }));
  }
}
