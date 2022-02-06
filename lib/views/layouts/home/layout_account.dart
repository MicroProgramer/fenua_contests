import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Container(
                    height: Get.height * 0.15,
                    width: Get.height * 0.15,
                    decoration: BoxDecoration(
                        border: Border.all(color: appTextColor, width: 7),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://pronovix.com/sites/default/files/blogpost/image/blogpost_joker_images_1200x800-01.png"))),
                  ),
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      height: Get.height * 0.04,
                      width: Get.height * 0.04,
                      decoration: BoxDecoration(
                          color: appTextColor, shape: BoxShape.circle),
                      child: Icon(Icons.edit),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mubashar Hussain",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * 0.03,
                        color: appTextColor),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.edit),
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
                        onTap: () {},
                        title: Text(
                          "Help".toUpperCase(),
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
                        onTap: () {},
                        title: Text(
                          "Privacy Policy".toUpperCase(),
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
                        onTap: () {},
                        title: Text(
                          "Terms And Conditions".toUpperCase(),
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
                            "Logout",
                            style: TextStyle(
                                color: appTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: (){
                      Get.defaultDialog(
                        middleText: "You will have no longer access to your account, Are you sure to delete your account?",
                        title: "Alert",
                        textConfirm: "Delete Account",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white
                      );
                    },
                    child: Text(
                      "Delete my account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
