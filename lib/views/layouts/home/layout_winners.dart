import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_winner.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WinnersLayout extends StatelessWidget {
  const WinnersLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return SafeArea(
      child: controller.getWonContests().length > 0
          ? ListView.builder(
              itemCount: controller.getWonContests().length,
              itemBuilder: (context, index) {
                Contest contest = controller.getWonContests()[index];
                return WinnerItem(
                  contest: contest,
                  winner: controller.getUserById(contest.winner_id),
                );
              })
          : NotFound(
              message: "No winners yet",
              color: Colors.black87,
            ),
    );
  }
}
