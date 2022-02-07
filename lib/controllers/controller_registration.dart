import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../views/screens/screen_home.dart';

class RegistrationController extends GetxController
    with GetTickerProviderStateMixin {
  List<String> animationStates = ['success', 'fail', 'test', 'idle'];
  var stateName = "idle".obs;
  late TabController tabController;
  XFile? oldPickedImage;
  ImagePicker _picker = ImagePicker();
  var selectedPage = 0.obs;
  List<bool> switches = [false, false, false].obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedPage.value = tabController.index;
    });
    super.onInit();
  }

  void updateAnimationState({Credentials? credentialsState}) {
    if (credentialsState == Credentials.success) {
      stateName.value = animationStates[0];
    } else if (credentialsState == Credentials.error) {
      stateName.value = animationStates[1];
    } else if (credentialsState == Credentials.typing) {
      stateName.value = animationStates[2];
    } else {
      stateName.value = animationStates[3];
    }
  }

  void getImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    oldPickedImage = pickedImage;
    print(pickedImage!.path.toString());
    update();
  }

  void changePageIndex(int index) {
    selectedPage.value = index;
  }

  void updateSwitch(int index, bool value) {
    switches[index] = value;
    update();
  }

  String submitFormStatus(FormType formType) {
    String status = "success";
    if (formType == FormType.signup){
      for (bool enabled in switches){
        if (!enabled) {
          status = "Make sure you check all the agreements";
          break;
        }
      }
    } else {
      status = "admin";
    }
    return status;
  }
}

enum Credentials { success, error, typing, idle }
enum FormType {login, signup}

