import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_field.dart';

class OrganizerItem extends StatelessWidget {
  Organizer organizer;

  String newName = "";

  String newWebsite = "";

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
            IconButton(
              onPressed: () {
                showOptionsBottomSheet(
                  context: context,
                  title: Text(
                    "Edit Options",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  options: [
                    ListTile(
                      title: Text("Edit Name"),
                      leading: Icon(Icons.drive_file_rename_outline),
                      onTap: () {
                        Get.back();
                        Get.defaultDialog(
                            title: "Update Organizer",
                            content: Column(
                              children: [
                                CustomInputField(
                                    hint: "Organizer Name",
                                    onChange: (value) {
                                      newName = value.toString();
                                    },
                                    isPasswordField: false,
                                    text: organizer.name,
                                    keyboardType: TextInputType.name),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                          color: appPrimaryColor,
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            if (!newName.isEmpty) {
                                              print(organizer.id);

                                              organizersRef
                                                  .doc(organizer.id)
                                                  .update({"name": newName})
                                                  .then((value) => Get.snackbar(
                                                      "Success".tr,
                                                      "Organizer name updated"))
                                                  .catchError((error) {
                                                    Get.snackbar("Error",
                                                        error.toString());
                                                  });
                                            }
                                          }),
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                          color: appPrimaryColor,
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      },
                    ),
                    ListTile(
                      title: Text("Edit Website"),
                      leading: Icon(Icons.drive_file_rename_outline),
                      onTap: () {
                        Get.back();
                        Get.defaultDialog(
                            title: "Update Website",
                            content: Column(
                              children: [
                                CustomInputField(
                                    hint: "Website",
                                    onChange: (value) {
                                      newWebsite = value.toString();
                                    },
                                    isPasswordField: false,
                                    text: organizer.website,
                                    keyboardType: TextInputType.name),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                          color: appPrimaryColor,
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            if (!newWebsite.isEmpty) {

                                              organizersRef
                                                  .doc(organizer.id)
                                                  .update({"website": newWebsite})
                                                  .then((value) => Get.snackbar(
                                                      "Success".tr,
                                                      "Organizer website updated"))
                                                  .catchError((error) {
                                                    Get.snackbar("Error",
                                                        error.toString());
                                                  });
                                            }
                                          }),
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                          color: appPrimaryColor,
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      },
                    ),
                    ListTile(
                      title: Text("Change Image"),
                      leading: Icon(Icons.image),
                      onTap: () {
                        Get.back();
                        controller.updateOrganizerImage(organizer.id);
                      },
                    ),
                  ],
                );
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  int contests =
                      controller.contestsByOrganizer(organizer.id).length;
                  if (contests != 0) {
                    Get.defaultDialog(
                        titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        confirmTextColor: Colors.white,
                        title: "Cannot Delete ${organizer.name}",
                        middleText:
                            "This organizer has organized ${contests} contests",
                        textConfirm: "Ok",
                        onConfirm: () {
                          Get.back();
                        });
                  } else {
                    controller.deleteOrganizer(organizer.id, organizer.name);
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
                  image: CachedNetworkImageProvider(organizer.image_url))),
        ),
      ),
    );
  }

  OrganizerItem({
    required this.organizer,
  });
}
