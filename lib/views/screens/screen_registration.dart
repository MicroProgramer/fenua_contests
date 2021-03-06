import 'package:fenua_contests/controllers/controller_registration.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/registration/layout_login.dart';
import 'package:fenua_contests/views/layouts/registration/layout_signup.dart';
import 'package:fenua_contests/widgets/custom_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RegistrationController(), fenix: true);

    return Scaffold(
      backgroundColor: appSecondaryColor,
      body: WillPopScope(
        onWillPop: () async {
          RegistrationController controller =
              Get.find<RegistrationController>();
          if (controller.selectedPage.value > 0) {
            controller.changePageIndex(0);
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: GetX<RegistrationController>(
            initState: (_) {},
            builder: (controller) {
              return ModalProgressHUD(
                inAsyncCall: controller.showLoading.value,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 100,
                        child: ClipOval(
                          child: Image.asset("assets/images/icon_gif.gif"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: CustomTabBarView(
                          tabs_length: 2,
                          tabs_titles_list: [LocaleKeys.SignIn.tr, LocaleKeys.SignUp.tr],
                          tabController:
                              Get.find<RegistrationController>().tabController,
                          tab_children_layouts: [LoginLayout(), SignupLayout()],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
