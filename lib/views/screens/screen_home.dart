import 'package:fenua_contests/controllers/controller_ads.dart';
import 'package:fenua_contests/interfaces/ads_listener.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/home/layout_account.dart';
import 'package:fenua_contests/views/layouts/home/layout_contests.dart';
import 'package:fenua_contests/views/screens/screen_contest_details.dart';
import 'package:fenua_contests/views/screens/srceen_wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controller_admin_home_screen.dart';
import '../../controllers/controller_home_screen.dart';
import '../layouts/home/layout_winners.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ContestsLayout(),
      WinnersLayout(),
      AccountLayout()
    ];

    Get.put(AdminHomeScreenController(), permanent: true);
    Get.put(HomeScreenController(), permanent: true);

    HomeScreenController controller = Get.find<HomeScreenController>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Get.to(WalletScreen());
              },
              child: Row(
                children: [
                  Icon(Icons.wallet_giftcard),
                  SizedBox(
                    width: 5,
                  ),
                  Hero(
                    tag: "wallet",
                    child: Obx(() {
                      return Text(controller.myTickets.length.toString());
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: appSecondaryColor,
        title: Text(appName),
      ),
      backgroundColor: appSecondaryColor,
      bottomNavigationBar: GetX<HomeScreenController>(
        initState: (_) {},
        builder: (logic) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                label: 'Contest',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag_outlined),
                label: 'Winners',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded),
                label: 'Account',
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
      body: WillPopScope(
        onWillPop: () async {
          if (controller.selectedPage.value > 0) {
            controller.changePageIndex(0);
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: GetX<HomeScreenController>(
            initState: (_) {},
            builder: (logic) {
              return Center(
                child: _widgetOptions[logic.selectedPage.value],
              );
            },
          ),
        ),
      ),
    );
  }

}
