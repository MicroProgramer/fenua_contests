import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerItem extends StatelessWidget {
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
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  int contests =
                      controller.contestsByOrganizer(organizer.id).length;
                  if (contests != 0) {
                    Get.defaultDialog(
                      confirmTextColor: Colors.white,
                      title: "Cannot Delete ${organizer.name}",
                      middleText:
                          "This organizer has organized ${contests} contests",
                      textConfirm: "Ok",
                      onConfirm: (){
                        Get.back();
                      }
                    );
                  }
                },
                icon: Icon(Icons.delete)),
          ],
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(organizer.image_url))),
        ),
      ),
    );
  }

  OrganizerItem({
    required this.organizer,
  });
}
