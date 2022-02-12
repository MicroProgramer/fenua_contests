import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/user_info.dart' as model;
import 'package:fenua_contests/widgets/custom_button.dart';
import 'package:fenua_contests/widgets/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ticket.dart';

class HomeScreenController extends GetxController {
  var selectedPage = 0.obs;
  XFile? oldPickedImage;
  ImagePicker _picker = ImagePicker();

  final myTickets = List<Ticket>.empty(growable: true).obs;

  var mUser = model.UserInfo(
          first_name: "User",
          last_name: "Name",
          nickname: "nickname",
          age: "age",
          city: "city",
          checked_0: false,
          checked_1: false,
          checked_2: false,
          id: "id",
          email: "email",
          password: "password",
          phone: "phone",
          image_url: "image_url")
      .obs;
  var showDpLoading = false.obs;
  Rx<TextEditingController> firstName_controller = TextEditingController().obs;
  Rx<TextEditingController> lastName_controller = TextEditingController().obs;

  @override
  void onInit() {
    myTickets.bindStream(myTicketsStream());
    listenForDocChange(FirebaseAuth.instance.currentUser!.uid);
    super.onInit();
  }

  void changePageIndex(int index) {
    selectedPage.value = index;
  }

  void getImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    oldPickedImage = pickedImage;
    Get.defaultDialog(
        title: "Are you sure to upload this image",
        content: Container(
          margin: EdgeInsets.all(10),
          height: Get.height * 0.2,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 10)],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(oldPickedImage!.path)),
              )),
        ),
        textConfirm: "Yes",
        confirmTextColor: Colors.white,
        textCancel: "Cancel",
        radius: 0,
        onConfirm: () async {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          Get.back();
          Get.snackbar("Please Wait", "Updating your profile picture",
              colorText: Colors.white, backgroundColor: Colors.black);
          String image_url = await _uploadImage(uid);
          await usersRef
              .doc(uid)
              .update({"image_url": image_url}).catchError((error) {
            Get.snackbar("Error", error.toString());
          });
          Get.snackbar("Success", "Profile image updated successfully");
          showDpLoading.value = false;
        },
        onCancel: () {
          Get.back();
        });
    update();
  }

  void listenForDocChange(String uid) {
    usersRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((changedDoc) {
        print(changedDoc.doc.data());
        model.UserInfo user = model.UserInfo.fromMap(
            changedDoc.doc.data() as Map<String, dynamic>);
        if (user.id == uid) {
          mUser.value = user;
          update();
        }
      });
    });
  }

  Future<String> _uploadImage(String uid) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("profile_images/${uid}.png");
    final UploadTask uploadTask =
        storageReference.putFile(File(oldPickedImage!.path));

    uploadTask.snapshotEvents.listen((event) {
      showDpLoading.value = true;
    }).onError((error) {
      // do something to handle error
      showDpLoading.value = false;
      Get.snackbar("Error", error.toString());
    });

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  void updateUserName() {
    Get.defaultDialog(
        title: "Update Name",
        content: Column(
          children: [
            CustomInputField(
                hint: "First Name",
                isPasswordField: false,
                controller: firstName_controller.value,
                text: mUser.value.first_name,
                keyboardType: TextInputType.name),
            CustomInputField(
                hint: "Last Name",
                controller: lastName_controller.value,
                text: mUser.value.last_name,
                isPasswordField: false,
                keyboardType: TextInputType.name),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      color: appPrimaryColor,
                      child: Text(
                        "Update",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        Get.back();
                        _updateNameInDb(FirebaseAuth.instance.currentUser!.uid);
                      }),
                ),
                Expanded(
                  child: CustomButton(
                      color: appPrimaryColor,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                ),
              ],
            ),
          ],
        ));
  }

  void _updateNameInDb(String uid) {
    String firstName = firstName_controller.value.text;
    String lastName = lastName_controller.value.text;
    if (!firstName.isEmpty && !lastName.isEmpty) {
      usersRef
          .doc(uid)
          .update({
            "first_name": firstName,
            "last_name": lastName,
          })
          .then((value) => Get.snackbar("Success", "Name updated successfully"))
          .catchError((error) {
            Get.snackbar("Error", error.toString());
          });
    }
  }

  Stream<List<Ticket>> myTicketsStream() {
    Stream<QuerySnapshot> stream = usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tickets")
        .snapshots();

    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> deleteTicket(String id) async {
    await usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tickets")
        .doc(id)
        .delete();
  }
}
