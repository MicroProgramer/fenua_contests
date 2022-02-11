import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_info.dart';

class AdminHomeScreenController extends GetxController {
  var selectedPage = 0.obs;
  final organizersList = List<Organizer>.empty(growable: true).obs;
  final contestsList = List<Contest>.empty(growable: true).obs;
  final usersList = List<UserInfo>.empty(growable: true).obs;
  
  XFile organizerImage = XFile("");
  ImagePicker _picker = ImagePicker();
  var showLoading = false.obs;
  Rx<TextEditingController> organizerName_controller =
      TextEditingController().obs;

  @override
  void onInit() {
    organizersList.bindStream(organizersStream());
    contestsList.bindStream(contestsStream());
    usersList.bindStream(usersStream());
    super.onInit();
  }

  void changePageIndex(int index) {
    selectedPage.value = index;
  }

  Stream<List<Organizer>> organizersStream() {
    Stream<QuerySnapshot> stream = organizersRef.snapshots();

    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => Organizer.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Stream<List<Contest>> contestsStream() {
    Stream<QuerySnapshot> stream = contestsRef.snapshots();

    return stream.map((querySnapshot) => querySnapshot.docs.map((doc) {
      print("data " + doc.data().toString());
      return Contest.fromMap(doc.data() as Map<String, dynamic>);
        }).toList());
  }

  Stream<List<UserInfo>> usersStream() {
    Stream<QuerySnapshot> stream = usersRef.snapshots();

    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => UserInfo.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  List<Contest> contestsByOrganizer(String organizer_id) {
    List<Contest> contests = [];
    for (var c in contestsList.value){
      if (c.organizer_id == organizer_id){
        contests.add(c);
      }
    }
    return contests;
  }

  Future<void> pickOrganizerImage() async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);
      organizerImage = pickedImage;
    }
    update();
  }

  Future<void> addOrganizer() async {
    String name = organizerName_controller.value.text;
    if (name.isEmpty) {
      Get.snackbar("Alert", "Please enter organizer name",
          colorText: Colors.white, backgroundColor: Colors.black);
      return;
    } else if (organizerImage.path == "") {
      Get.snackbar("Alert", "Please select logo for organizer",
          colorText: Colors.white, backgroundColor: Colors.black);
      return;
    }

    int id = DateTime.now().millisecondsSinceEpoch;
    showLoading.value = true;
    String logo_url = await _uploadOrganizerLogo(id.toString());
    Organizer organizer =
        Organizer(id: id.toString(), name: name, image_url: logo_url);

    organizersRef.doc(id.toString()).set(organizer.toMap()).then((value) {
      showLoading.value = false;
    });
  }

  Future<String> _uploadOrganizerLogo(String organizer_id) async {
    Get.snackbar("Uploading Image", "Uploading organizer image to database");
    Reference storageReference =
        FirebaseStorage.instance.ref().child("organizers/${organizer_id}.png");
    final UploadTask uploadTask =
        storageReference.putFile(File(organizerImage.path));

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

  Organizer? getOrganizerById(String id){
    for (var organizer in organizersList){
      if (organizer.id == id){
        return organizer;
      }
    }

    return null;
  }

  Contest? getContestById(String contest_id){
    for (var c in contestsList){
      if (c.id == contest_id){
        return c;
      }
    }
    return null;
  }
}
