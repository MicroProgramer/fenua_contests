import 'package:fenua_contests/controllers/controller_registration.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/screens/screen_home.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/admin/screen_admin_home.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegistrationController controller = Get.find<RegistrationController>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomInputField(
              hint: "Email Address",
              isPasswordField: false,
              controller: controller.email_controller.value,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomInputField(
              hint: "Password",
              isPasswordField: true,
              controller: controller.password_controller.value,
              keyboardType: TextInputType.visiblePassword,
            ),
            CustomButton(
              color: appPrimaryColor,
              child: Text(
                "Login",
                style:
                    TextStyle(color: appTextColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                String status = await controller.signIn();

                if (status == "success") {
                  Get.off(HomeScreen());
                } else if (status == "admin") {
                  Get.off(AdminHomeScreen());
                } else {
                  Get.snackbar("Alert", status,
                      backgroundColor: Colors.black, colorText: Colors.white);
                }
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: appTextColor),
                  ),
                  GestureDetector(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: appPrimaryColor),
                    ),
                    onTap: () {
                      controller.tabController.index = 1;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
