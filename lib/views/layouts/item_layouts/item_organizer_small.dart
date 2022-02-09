import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerSmallItem extends StatelessWidget {
  Organizer organizer;

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white,
        title: Text("${organizer.name}"),
        subtitle: GetBuilder<AdminHomeScreenController>(
          assignId: true,
          builder: (logic) {
            return Text(
                "Organized ${logic.contestsByOrganizer(organizer.id).length} contests");
          },
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(organizer.image_url))),
        ),
      ),
    );
  }

  OrganizerSmallItem({
    required this.organizer,
  });
}
