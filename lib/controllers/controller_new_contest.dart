import 'dart:io';

import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewContestController extends GetxController {
  List<XFile> images = [XFile(""), XFile(""), XFile("")].obs;
  ImagePicker _picker = ImagePicker();
  var organizer_dropdown_value = "".obs;
  late Rx<int> startTimestamp;
  late Rx<int> endTimestamp;
  Rx<DateTime> _currentDate = DateTime.now().obs;
  Rx<TextEditingController> title_controller = TextEditingController().obs,
      description_controller =  TextEditingController().obs;
  var showLoading = false.obs;

  var participantsCheck = false.obs;

  Future<void> pickImage({required int index}) async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);
      images[index] = pickedImage;
      print(images[index].path);
    }
    update();
  }

  void updateParticipantsCheck(bool status) {
    participantsCheck.value = status;
    update();
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
    update();
  }

  void updateStartDate(DateTime selectedDate) {
    startTimestamp.value = selectedDate.millisecondsSinceEpoch;
    update();

  }

  void updateEndDate(DateTime selectedDate) {
    endTimestamp.value = selectedDate.millisecondsSinceEpoch;
    update();

  }

  Future<String> addContest() async {
    for (XFile image in images) {
      if (image.path == "") {
        _showSnack("Please select all images");
        return "";
      }
    }
    String title = title_controller.value.text;
    String description = description_controller.value.text;
    if (title.isEmpty || description.isEmpty) {
      _showSnack("All fields are required");
      return "";
    } else if (startTimestamp.value > endTimestamp.value) {
      _showSnack("Invalid ending date");
      return "";
    }
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    showLoading.value = true;
    String url_0 = await _uploadImage(id, 0);
    String url_1 = await _uploadImage(id, 1);
    String url_2 = await _uploadImage(id, 2);

    Contest contest = Contest(
        id: id,
        name: title,
        images: [url_0, url_1, url_2],
        description: description,
        start_timestamp: startTimestamp.value,
        end_timestamp: endTimestamp.value,
        winner_id: "",
        organizer_id: organizer_dropdown_value.value,
        show_participants_info: participantsCheck.value);

    String response = "";
    await contestsRef.doc(id).set(contest.toMap()).then((value) {
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

  Future<String> _uploadImage(String contest_id, int index) async {
    Get.snackbar("Uploading Image", "Uploading organizer image to database");
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("contests/${contest_id}_$index.png");
    final UploadTask uploadTask =
        storageReference.putFile(File(images[index].path));

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
