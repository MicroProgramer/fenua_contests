import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../item_layouts/item_contest.dart';

class ContestsLayout extends StatelessWidget {
  const ContestsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Obx(() {
      return controller.contestsList.length > 0
          ? ListView.builder(
              itemCount: controller.contestsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContestItem(
                    controller: controller,
                    contest: controller.contestsList[index],
                  ),
                );
              })
          : NotFound(color: Colors.black87, message: "No Contests");
    });
  }
}
