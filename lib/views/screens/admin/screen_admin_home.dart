import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/views/layouts/admin/layout_contests_admin.dart';
import 'package:fenua_contests/views/layouts/admin/layout_users_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../../helpers/styles.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AdminHomeScreenController(), fenix: true);

    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    List<Widget> _widgetOptions = <Widget>[
      ContestsAdminLayout(),
      UsersLayoutAdmin(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text("Admin Area"),
      ),
      backgroundColor: appSecondaryColor,
      bottomNavigationBar: GetX<AdminHomeScreenController>(
        initState: (_) {},
        builder: (logic) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                label: 'Contests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account),
                label: 'Users',
              ),
            ],
            currentIndex: controller.selectedPage.value,
            selectedItemColor: Colors.black,
            unselectedItemColor: appTextColor,
            backgroundColor: appSecondaryColor,
            onTap: (index) {
              controller.changePageIndex(index);
            },
          );
        },
      ),
      body: Container(
        child: Obx(() {
          return _widgetOptions[controller.selectedPage.value];
        }),
      ),
    );
  }
}
