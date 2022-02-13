import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/models/shared_user.dart';
import 'package:fenua_contests/models/user_info.dart' as model;
import 'package:fenua_contests/views/screens/admin/screen_admin_home.dart';
import 'package:fenua_contests/views/screens/screen_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/constants.dart';

class RegistrationController extends GetxController
    with GetTickerProviderStateMixin {
  List<String> animationStates = ['success', 'fail', 'test', 'idle'];
  var stateName = "idle".obs;
  late TabController tabController;
  XFile? oldPickedImage;
  ImagePicker _picker = ImagePicker();
  var selectedPage = 0.obs;
  List<bool> switches = [false, false, false].obs;
  var showLoading = false.obs;
  Rx<TextEditingController> firstName_controller = TextEditingController().obs,
      lastName_controller = TextEditingController().obs,
      age_controller = TextEditingController().obs,
      city_controller = TextEditingController().obs,
      nickName_controller = TextEditingController().obs,
      email_controller = TextEditingController().obs,
      password_controller = TextEditingController().obs,
      confirm_password_controller = TextEditingController().obs,
      phone_controller = TextEditingController().obs;

  var _adminEmail = "admin";
  var _adminPass = "admin";

  @override
  Future<void> onInit() async {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedPage.value = tabController.index;
    });

    if (!GetPlatform.isWeb){
      SharedUser sharedUser = await getUserFromSharedPrefs();
      if (!sharedUser.userType.isEmpty) {
        if (sharedUser.userType == "admin") {
          Get.off(AdminHomeScreen());
        } else if (sharedUser.userType == "user") {
          Get.off(HomeScreen());
        }
      }
    }

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
    if (formType == FormType.signup) {
      for (bool enabled in switches) {
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

  Future<String> createAccount() async {
    String email = email_controller.value.text;
    String password = password_controller.value.text;
    String phone = phone_controller.value.text;
    String first_name = firstName_controller.value.text;
    String last_name = lastName_controller.value.text;
    String nick_name = nickName_controller.value.text;
    String age = age_controller.value.text;
    String city = city_controller.value.text;
    bool checked0 = switches[0];
    bool checked1 = switches[1];
    bool checked2 = switches[2];

    if (oldPickedImage == null) {
      return "Please select your image";
    } else if (email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        first_name.isEmpty ||
        last_name.isEmpty ||
        age.isEmpty ||
        city.isEmpty) {
      return "Fill all fields";
    } else if (!email.isEmail) {
      return "Invalid Email Address";
    } else {
      showLoading.value = true;
      String auth_error = '';
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((auth) async {
        Get.snackbar("Please wait", "Creating your account");
        if (auth != null) {
          String url = await _uploadImage(auth.user!.uid);
          if (url.isEmpty) {
            Get.snackbar("Error", "Image not uploaded");
          }
          auth_error = await _setDatabase(model.UserInfo(
              first_name: first_name,
              last_name: last_name,
              nickname: nick_name,
              age: age,
              city: city,
              checked_0: checked0,
              checked_1: checked1,
              checked_2: checked2,
              id: auth.user!.uid,
              email: email,
              password: password,
              phone: phone,
              image_url: url));
        }
      }).catchError((error) {
        auth_error = error.toString();
        Get.snackbar("Error", error.toString());
      });

      return auth_error;
    }
  }

  Future<String> signIn() async {
    String email = email_controller.value.text;
    String password = password_controller.value.text;

    if (email.isEmpty || password.isEmpty) {
      return "Both fields are required";
    } else if (email.toLowerCase() == _adminEmail ||
        password.toLowerCase() == _adminPass) {
      saveSharedPref(SharedUser(id: "admin", name: "Admin", userType: "admin"));
      return "admin";
    } else {
      String auth_error = "";
      showLoading.value = true;
      var auth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        auth_error = error.toString();
      });
      showLoading.value = false;
      if (auth != null) {
        saveSharedPref(
            SharedUser(id: auth.user!.uid, name: "User", userType: "user"));
        return "success";
      } else {
        return auth_error;
      }
    }
  }

  Future<String> _uploadImage(String uid) async {
    Get.snackbar("Uploading Image", "Uploading your image to database");
    Reference storageReference =
        FirebaseStorage.instance.ref().child("profile_images/${uid}.png");
    final UploadTask uploadTask =
        storageReference.putFile(File(oldPickedImage!.path));

    uploadTask.snapshotEvents.listen((event) {
      showLoading.value = true;
    }).onError((error) {
      // do something to handle error
      showLoading.value = false;
    });

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  Future<String> _setDatabase(model.UserInfo info) async {
    String response = "";
    showLoading.value = true;
    usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(info.toMap())
        .then((value) {
      response = "success";
    }).catchError((error) {
      response = error.toString();
    });
    return response;
  }
}

enum Credentials { success, error, typing, idle }
enum FormType { login, signup }
