import 'dart:io';
import 'package:fenua_contests/controllers/controller_registration.dart';
import 'package:fenua_contests/generated/locales.g.dart';
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
          CustomInputField(
            hint: LocaleKeys.FirstName.tr,
            isPasswordField: false,
            keyboardType: TextInputType.name,
            controller: controller.firstName_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.LastName.tr,
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.lastName_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.Nickname.tr,
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.nickName_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.DateofBirth.tr,
            keyboardType: TextInputType.datetime,
            isPasswordField: false,
            controller: controller.age_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.City.tr,
            keyboardType: TextInputType.name,
            isPasswordField: false,
            controller: controller.city_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.PhoneNumber.tr,
            keyboardType: TextInputType.phone,
            isPasswordField: false,
            controller: controller.phone_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.Email.tr,
            keyboardType: TextInputType.emailAddress,
            isPasswordField: false,
            controller: controller.email_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.Password.tr,
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            controller: controller.password_controller.value,
          ),
          CustomInputField(
            hint: LocaleKeys.ConfirmPassword.tr,
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
                  title: Text(LocaleKeys.term1.tr),
                ),
                SwitchListTile.adaptive(
                  activeColor: appPrimaryColor,
                  value: controller.switches[1],
                  onChanged: (value) {
                    controller.updateSwitch(1, value);
                  },
                  title: Text(LocaleKeys.term2.tr),
                ),
                SwitchListTile.adaptive(
                  activeColor: appPrimaryColor,
                  value: controller.switches[2],
                  onChanged: (value) {
                    controller.updateSwitch(2, value);
                  },
                  title: Text(LocaleKeys.term3.tr),
                ),
              ],
            );
          }),
          CustomButton(
              color: appPrimaryColor,
              child: Text(
                LocaleKeys.SignUp.tr,
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
                  LocaleKeys.Alreadyhaveanaccount.tr + " ",
                  style: TextStyle(color: appTextColor),
                ),
                GestureDetector(
                  child: Text(
                    LocaleKeys.SignIn.tr,
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
