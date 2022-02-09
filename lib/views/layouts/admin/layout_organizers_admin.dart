import 'dart:io';

import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_organizer.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizersLayoutAdmin extends StatelessWidget {
  const OrganizersLayoutAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Scaffold(
      backgroundColor: appSecondaryColor,
      body: Obx(() {
        print(controller.organizersList.length);
        return controller.organizersList.length > 0
            ? ListView.builder(
                itemCount: controller.organizersList.length,
                itemBuilder: (_, index) {
                  return OrganizerItem(
                      organizer: controller.organizersList[index]);
                })
            : Container(
                margin: EdgeInsets.only(top: 100),
                child: Text(
                  "No Data",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
              title: "New Organizer",
              content: GetBuilder<AdminHomeScreenController>(
                assignId: true,
                builder: (controller) {
                  return Container(
                    child: Column(
                      children: [
                        CustomInputField(
                            hint: "Organizer Name",
                            isPasswordField: false,
                            controller: controller.organizerName_controller.value,
                            keyboardType: TextInputType.name),
                        Text("Logo"),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: Get.height * 0.1,
                            width: 100,
                            child: controller.organizerImage.path != ""
                                ? Container()
                                : Icon(Icons.add),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: controller.organizerImage.path != ""
                                    ? DecorationImage(
                                        image: FileImage(File(
                                            controller.organizerImage.path)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                ]),
                          ),
                          onTap: () {
                            controller.pickOrganizerImage();
                          },
                        ),
                        CustomButton(
                            width: 150,
                            color: appPrimaryColor,
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              Get.back();
                              await controller.addOrganizer();
                            }),
                      ],
                    ),
                  );
                },
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
