import 'dart:io';
import 'package:fenua_contests/controllers/controller_registration.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/screens/screen_home.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_input_field.dart';

class SignupLayout extends StatelessWidget {
  RegistrationController controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    double height = Get.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetBuilder<RegistrationController>(
            init: controller,
            builder: (logic) {
              print(logic.stateName);
              return GestureDetector(
                child: CircleAvatar(
                  radius: height * 0.08,
                  backgroundImage: controller.oldPickedImage == null
                      ? AssetImage("assets/images/placeholder.jpg")
                      : FileImage(File(controller.oldPickedImage!.path))
                          as ImageProvider,
                ),
                onTap: () async {
                  controller.getImage();
                },
              );
            },
          ),
          CustomInputField(
            hint: "First Name",
            isPasswordField: false,
            keyboardType: TextInputType.name,
            controller: controller.firstName_controller.value,
          ),
          CustomInputField(
            hint: "Last Name",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.lastName_controller.value,
          ),
          CustomInputField(
            hint: "Nickname",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.nickName_controller.value,
          ),
          CustomInputField(
            hint: "Age",
            keyboardType: TextInputType.number,
            isPasswordField: false,
            controller: controller.age_controller.value,
          ),
          CustomInputField(
            hint: "City",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.city_controller.value,
          ),
          CustomInputField(
            hint: "Phone Number",
            keyboardType: TextInputType.phone,
            isPasswordField: false,
            controller: controller.phone_controller.value,
          ),
          CustomInputField(
            hint: "Email",
            keyboardType: TextInputType.emailAddress,
            isPasswordField: false,
            controller: controller.email_controller.value,
          ),
          CustomInputField(
            hint: "Password",
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            controller: controller.password_controller.value,
          ),
          CustomInputField(
            hint: "Confirm Password",
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            controller: controller.confirm_password_controller.value,
          ),
          Obx(() {
            return Column(
              children: [
                SwitchListTile.adaptive(
                  activeColor: appPrimaryColor,
                  value: controller.switches[0],
                  onChanged: (value) {
                    controller.updateSwitch(0, value);
                  },
                  title: Text(
                      "I agree to receive commercial offers from FENUA CONTESTS - 100% FREE and its partners"),
                ),
                SwitchListTile.adaptive(
                  activeColor: appPrimaryColor,
                  value: controller.switches[1],
                  onChanged: (value) {
                    controller.updateSwitch(1, value);
                  },
                  title: Text(
                      "I acknowledge having read and accepted the general conditions of use of the application"),
                ),
                SwitchListTile.adaptive(
                  activeColor: appPrimaryColor,
                  value: controller.switches[2],
                  onChanged: (value) {
                    controller.updateSwitch(2, value);
                  },
                  title: Text(
                      "I certify that I am over 18 years of age or a authorization of my legal representative"),
                ),
              ],
            );
          }),
          CustomButton(
              color: appPrimaryColor,
              child: Text(
                "Sign up",
                style:
                    TextStyle(color: appTextColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                String response = await controller.createAccount();
                if (response == "success") {
                  Get.to(HomeScreen());
                } else {
                  showSnackBar(response, context);
                }
              }),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: appTextColor),
                ),
                GestureDetector(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: appPrimaryColor),
                  ),
                  onTap: () {
                    controller.tabController.index = 0;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
