import 'package:cached_network_image/cached_network_image.dart';
import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/controllers/controller_home_screen.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/screens/screen_registration.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.find<HomeScreenController>();

    return Obx(() {
      return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: Get.height * 0.15,
                      width: Get.height * 0.15,
                      decoration: BoxDecoration(
                          border: Border.all(color: appTextColor, width: 7),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  controller.mUser.value.image_url))),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: InkWell(
                        onTap: () {
                          controller.getImage();
                        },
                        child: Container(
                          height: Get.height * 0.04,
                          width: Get.height * 0.04,
                          decoration: BoxDecoration(
                              color: appTextColor, shape: BoxShape.circle),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Visibility(
                        visible: controller.showDpLoading.value,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${controller.mUser.value.first_name} ${controller.mUser.value.last_name}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.height * 0.03,
                            color: appTextColor),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    IconButton(onPressed: (){
                      controller.updateUserName();
                    }, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
              Divider(
                height: 40,
                // color: Colors.red[900],
                thickness: 2,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: appPrimaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            launchUrl(Get.find<AdminHomeScreenController>().links!.help);
                          },
                          title: Text(
                            LocaleKeys.HELP.tr.toUpperCase(),
                            style: TextStyle(color: appTextColor),
                          ),
                          trailing: Icon(
                            Icons.navigate_next_outlined,
                            color: appTextColor,
                          ),
                        ),
                        Divider(
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        ListTile(
                          onTap: () {
                            launchUrl(Get.find<AdminHomeScreenController>().links!.privacy_policy);
                          },
                          title: Text(
                            LocaleKeys.PRIVACYPOLICY.tr.toUpperCase(),
                            style: TextStyle(color: appTextColor),
                          ),
                          trailing: Icon(
                            Icons.navigate_next_outlined,
                            color: appTextColor,
                          ),
                        ),
                        Divider(
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        ListTile(
                          onTap: () {
                            launchUrl(Get.find<AdminHomeScreenController>().links!.terms_conditions);
                          },
                          title: Text(
                            LocaleKeys.TERMSANDCONDITIONS.tr.toUpperCase(),
                            style: TextStyle(color: appTextColor),
                          ),
                          trailing: Icon(
                            Icons.navigate_next_outlined,
                            color: appTextColor,
                          ),
                        ),
                        Divider(
                          color: Colors.white54,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: CustomButton(
                            width: Get.width * 0.5,
                            color: Color(0xff920000),
                            child: Text(
                              LocaleKeys.Logout.tr,
                              style: TextStyle(
                                  color: appTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                  title: LocaleKeys.Logout.tr,
                                  middleText: LocaleKeys.Areyousuretologout.tr,
                                  confirmTextColor: Colors.white,
                                  textCancel: "No".tr,
                                  textConfirm: "Yes".tr,
                                  onConfirm: () async {
                                    await FirebaseAuth.instance.signOut();
                                    await logoutSharedUser();
                                    Get.deleteAll(force: true);
                                    Get.offAll(RegistrationScreen());
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(18.0),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Get.defaultDialog(
                  //           middleText:
                  //               "You will have no longer access to your account, Are you sure to delete your account?",
                  //           title: "Alert",
                  //           textConfirm: "Delete Account",
                  //           textCancel: "Cancel",
                  //           confirmTextColor: Colors.white);
                  //     },
                  //     child: Text(
                  //       "Delete my account",
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  // String getOrganizerWebsite(String id) {
  //   for (var organizer in controller.organizersList) {
  //     if (organizer.id == id) {
  //       return organizer.website;
  //     }
  //   }
  //   return "";
  // }
}
