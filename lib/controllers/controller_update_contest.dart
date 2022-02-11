import 'dart:io';

import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateContestController extends GetxController {
  List<String> images = ["", "", ""].obs;
  ImagePicker _picker = ImagePicker();
  var organizer_dropdown_value = "".obs;
  late Rx<int> startTimestamp;
  late Rx<int> endTimestamp;
  Rx<DateTime> _currentDate = DateTime.now().obs;
  Rx<TextEditingController> title_controller = TextEditingController().obs,
      description_controller = TextEditingController().obs;
  var showLoading = false.obs;
  var winner_id = "".obs;
  var participantsCheck = false.obs;
  var contest_id = "".obs;

  Future<void> pickImage({required int index}) async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);

      Get.defaultDialog(
          title: "Are you sure to upload this image",
          content: Container(
            margin: EdgeInsets.all(10),
            height: Get.height * 0.2,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 10)],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(pickedImage.path)),
                )),
          ),
          textConfirm: "Yes",
          confirmTextColor: Colors.white,
          textCancel: "Cancel",
          radius: 0,
          onConfirm: () async {
            Get.back();
            String image_url =
                await _uploadImage(contest_id.value, index, pickedImage.path);
            images[index] = image_url;
            await contestsRef
                .doc(contest_id.value)
                .update({"images": images}).catchError((error) {
              Get.snackbar("Error", error.toString());
            });
            Get.snackbar("Success", "Image ${index + 1} updated");
            showLoading.value = false;
          },
          onCancel: () {
            Get.back();
          });
    }
    update();
  }

  void updateParticipantsCheck(bool status) {
    participantsCheck.value = status;
  }

  @override
  void onInit() {
    organizer_dropdown_value.value =
        Get.find<AdminHomeScreenController>().organizersList[0].id;
    startTimestamp = DateTime.now().millisecondsSinceEpoch.obs;
    _currentDate.value = DateTime(_currentDate.value.year,
        _currentDate.value.month, _currentDate.value.day + 2);
    endTimestamp = _currentDate.value.millisecondsSinceEpoch.obs;
    super.onInit();
  }

  void updateDropdown(String value) {
    organizer_dropdown_value.value = value;
  }

  void updateStartDate(DateTime selectedDate) {
    startTimestamp.value = selectedDate.millisecondsSinceEpoch;
  }

  void updateEndDate(DateTime selectedDate) {
    endTimestamp.value = selectedDate.millisecondsSinceEpoch;
  }

  Future<String> updateContest(String id) async {
    String title = title_controller.value.text;
    String description = description_controller.value.text;
    if (title.isEmpty || description.isEmpty) {
      _showSnack("All fields are required");
      return "";
    } else if (startTimestamp.value > endTimestamp.value) {
      _showSnack("Invalid ending date");
      return "";
    }

    String response = "";
    await contestsRef.doc(id).update({
      "title": title,
      "description": description,
      "start_timestamp": startTimestamp.value,
      "end_timestamp": endTimestamp.value,
      "winner_id": winner_id.value,
      "organizer_id": organizer_dropdown_value.value,
      "show_participants_info": participantsCheck.value
    }).then((value) {
      response = "success";
    }).catchError((error) {
      response = error.toString();
    });

    showLoading.value = false;
    return response;
  }

  void _showSnack(String message) {
    Get.snackbar("Alert", message,
        colorText: Colors.white, backgroundColor: Colors.black);
  }

  Future<String> _uploadImage(String contest_id, int index, String path) async {
    Get.snackbar("Uploading Image", "Uploading organizer image to database");
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("contests/${contest_id}_$index.png");
    final UploadTask uploadTask = storageReference.putFile(File(path));

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
}
