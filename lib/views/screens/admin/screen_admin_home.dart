import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/views/layouts/admin/layout_contests_admin.dart';
import 'package:fenua_contests/views/layouts/admin/layout_links.dart';
import 'package:fenua_contests/views/layouts/admin/layout_organizers_admin.dart';
import 'package:fenua_contests/views/layouts/admin/layout_users_admin.dart';
import 'package:fenua_contests/views/screens/screen_registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../helpers/styles.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Get.put(AdminHomeScreenController(), permanent: true);
    // Get.lazyPut(() => AdminHomeScreenController(), fenix: true);

    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    List<Widget> _widgetOptions = <Widget>[
      ContestsAdminLayout(),
      UsersLayoutAdmin(),
      OrganizersLayoutAdmin(),
      LinksLayout(),
    ];



    return Scaffold(
      appBar: AppBar(
        backgroundColor: appSecondaryColor,
        title: Text("Admin Area"),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure to logout?",
                textCancel: "No",
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  await logoutSharedUser();
                  Get.offAll(RegistrationScreen());
                },
                onCancel: (){
                  Get.back();
                }
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
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
              BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account),
                label: 'Organizers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.link),
                label: 'Links',
              ),
            ],
            currentIndex: controller.selectedPage.value,
            selectedItemColor: Colors.black,
            unselectedItemColor: appTextColor,
            backgroundColor: appSecondaryColor,
              type: BottomNavigationBarType.fixed,
            onTap: (index) {
              controller.changePageIndex(index);
            },
          );
        },
      ),
      body: Container(
        child: Obx(() {
          return ModalProgressHUD(
              inAsyncCall: controller.showLoading.value,
              child: _widgetOptions[controller.selectedPage.value]);
        }),
      ),
    );
  }
}
