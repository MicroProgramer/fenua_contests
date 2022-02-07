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
    String _firstname = "",
        _lastname = "",
        _email = "",
        _phone = "",
        _password = "",
        _confirmPassword = "";
    String _country_code = "";

    // FirebaseAuth? _auth;
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    bool buttonEnabled = true;
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
            onChange: (value) {
              _firstname = value.toString();
            },
          ),
          CustomInputField(
            hint: "Last Name",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            onChange: (value) {
              _lastname = value.toString();
            },
          ),
          CustomInputField(
            hint: "Nickname",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            onChange: (value) {
              _lastname = value.toString();
            },
          ),
          CustomInputField(
            hint: "Age",
            keyboardType: TextInputType.number,
            isPasswordField: false,
            onChange: (value) {
              _lastname = value.toString();
            },
          ),
          CustomInputField(
            hint: "City",
            keyboardType: TextInputType.name,
            isPasswordField: false,
            onChange: (value) {
              _lastname = value.toString();
            },
          ),
          CustomInputField(
            hint: "Phone Number",
            keyboardType: TextInputType.phone,
            isPasswordField: false,
            onChange: (value) {
              _lastname = value.toString();
            },
          ),
          CustomInputField(
            hint: "Email",
            keyboardType: TextInputType.emailAddress,
            isPasswordField: false,
            onChange: (value) {
              _email = value.toString();
            },
          ),
          CustomInputField(
            hint: "Password",
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            onChange: (value) {
              _password = value.toString();
            },
          ),
          CustomInputField(
            hint: "Confirm Password",
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            onChange: (value) {
              _confirmPassword = value.toString();
            },
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
              onPressed: () {
                String status = controller.submitFormStatus(FormType.signup);
                if (status != "success"){
                  print(status);
                  showSnackBar(status, context);
                  return;
                }
                Get.to(HomeScreen());
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