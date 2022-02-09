import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersLayoutAdmin extends StatelessWidget {
  const UsersLayoutAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Scaffold(
      backgroundColor: appSecondaryColor,
      body: controller.usersList.length > 0
          ? ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (_, index) {
                return UserItem(
                  user: controller.usersList[index],
                );
              })
          : Center(child: Text("No users yet")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Export Data",
        child: Icon(Icons.save),
      ),
    );
  }
}
