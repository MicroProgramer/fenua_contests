import 'package:fenua_contests/controllers/controller_registration.dart';
import 'package:fenua_contests/helpers/styles.dart';
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
              onChange: (value) {
                controller.updateAnimationState(
                    credentialsState:
                        value!.isEmpty ? Credentials.idle : Credentials.typing);
              },
              keyboardType: TextInputType.emailAddress,
            ),
            CustomInputField(
              hint: "Password",
              isPasswordField: true,
              onChange: (value) {
                controller.updateAnimationState(
                    credentialsState:
                        value!.isEmpty ? Credentials.idle : Credentials.typing);
              },
              keyboardType: TextInputType.emailAddress,
            ),
            CustomButton(
              color: appPrimaryColor,
              child: Text(
                "Login",
                style:
                    TextStyle(color: appTextColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String status = controller.submitFormStatus(FormType.login);

                if (status == "success") {
                } else if (status == "admin") {
                  Get.to(AdminHomeScreen());
                } else {
                  Get.bottomSheet(Container(
                    height: 100,
                    color: Colors.red,
                    child: Center(
                        child: Text(
                          status,
                          style: normal_h3Style,
                        )),
                  ));

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
