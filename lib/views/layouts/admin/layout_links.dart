import 'package:fenua_contests/generated/locales.g.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../controllers/controller_admin_home_screen.dart';

class LinksLayout extends StatelessWidget {
  const LinksLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<AdminHomeScreenController>();

    return Obx(() {
      return ModalProgressHUD(
        inAsyncCall: controller.showLoading.value,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomInputField(
                    hint: LocaleKeys.GameRules.tr,
                    isPasswordField: false,
                    text: controller.links!.game_rules,
                    controller: controller.game_rules_controller.value,
                    keyboardType: TextInputType.text),
                CustomInputField(
                    hint: LocaleKeys.HELP.tr,
                    isPasswordField: false,
                    text: controller.links!.help,
                    controller: controller.help_controller.value,
                    keyboardType: TextInputType.text),
                CustomInputField(
                    hint: LocaleKeys.PRIVACYPOLICY.tr,
                    isPasswordField: false,
                    controller: controller.privacy_policy_controller.value,
                    text: controller.links!.privacy_policy,
                    keyboardType: TextInputType.text),
                CustomInputField(
                    hint: LocaleKeys.TERMSANDCONDITIONS.tr,
                    isPasswordField: false,
                    controller: controller.terms_controller.value,
                    text: controller.links!.terms_conditions,
                    keyboardType: TextInputType.text),
                SizedBox(height: Get.height * 0.3,),
                CustomButton(
                  color: appPrimaryColor,
                  child: Text("Update", style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    controller.updateLinks();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
