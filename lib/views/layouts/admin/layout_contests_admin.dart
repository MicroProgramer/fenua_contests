import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_contest_admin.dart';
import 'package:fenua_contests/views/screens/admin/screen_add_new_contest.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContestsAdminLayout extends StatelessWidget {
  const ContestsAdminLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Scaffold(
        backgroundColor: appSecondaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (controller.organizersList.length < 1) {
              Get.snackbar("Alert", "Must Add 1 organizer",
                  colorText: Colors.white, backgroundColor: Colors.black);
              return;
            }
            Get.to(AddNewContestScreen());
          },
          child: Icon(Icons.add),
        ),
        body: Obx(() {
          return controller.contestsList.length > 0
              ? ListView.builder(
                  itemCount: controller.contestsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContestItemAdmin(
                        controller_1: controller,
                        contest: controller.contestsList[index],
                      ),
                    );
                  })
              : NotFound(color: Colors.black87, message: "No Contests yet");
        }));
  }
}
