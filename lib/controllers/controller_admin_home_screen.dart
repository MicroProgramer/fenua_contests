import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ticket.dart';
import '../models/user_info.dart';

class AdminHomeScreenController extends GetxController {
  var selectedPage = 0.obs;
  final organizersList = List<Organizer>.empty(growable: true).obs;
  final contestsList = List<Contest>.empty(growable: true).obs;
  final usersList = List<UserInfo>.empty(growable: true).obs;
  final ticketsList = List<Ticket>.empty(growable: true).obs;
  final participantsMap = Map<String, List<Ticket>>().obs;

  XFile organizerImage = XFile("");
  ImagePicker _picker = ImagePicker();
  XFile? oldPickedImage;
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

  Stream<List<Ticket>> participantsStream(String contest_id) {
    Stream<QuerySnapshot> stream =
        contestsRef.doc(contest_id).collection("tickets").snapshots();

    return stream.map((querySnapshot) {
      participantsMap.value.clear();

      return querySnapshot.docs.map((doc) {
        Ticket ticket = Ticket.fromMap(doc.data() as Map<String, dynamic>);

        if (!participantsMap.containsKey(ticket.user_id)) {
          participantsMap.addAll({ticket.user_id: []});
        }
        participantsMap.update(ticket.user_id, (value) {
          value.add(ticket);
          return value;
        });

        return ticket;
      }).toList();
    });
  }

  List<Contest> contestsByOrganizer(String organizer_id) {
    List<Contest> contests = [];
    for (var c in contestsList.value) {
      if (c.organizer_id == organizer_id) {
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

  Organizer? getOrganizerById(String id) {
    for (var organizer in organizersList) {
      if (organizer.id == id) {
        return organizer;
      }
    }

    return null;
  }

  Contest? getContestById(String contest_id) {
    for (var c in contestsList) {
      if (c.id == contest_id) {
        return c;
      }
    }
    return null;
  }

  Future<void> updateOrganizerImage(String id) async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    oldPickedImage = pickedImage;
    Get.defaultDialog(
        title: "Are you sure to upload this image",
        content: Container(
          margin: EdgeInsets.all(10),
          height: Get.height * 0.1,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 10)],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(File(oldPickedImage!.path)),
              )),
        ),
        textConfirm: "Yes",
        confirmTextColor: Colors.white,
        textCancel: "Cancel",
        radius: 0,
        onConfirm: () async {
          Get.back();
          Get.snackbar("Please Wait", "Updating organizer picture",
              colorText: Colors.white, backgroundColor: Colors.black);
          String image_url = await _uploadImage(id);
          await organizersRef
              .doc(id)
              .update({"image_url": image_url}).catchError((error) {
            Get.snackbar("Error", error.toString());
          });
          Get.snackbar("Success", "Organizer image updated successfully");
        },
        onCancel: () {
          Get.back();
        });
    update();
  }

  Future<String> _uploadImage(String id) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("organizers/${id}.png");
    final UploadTask uploadTask =
        storageReference.putFile(File(oldPickedImage!.path));

    uploadTask.snapshotEvents.listen((event) {}).onError((error) {
      // do something to handle error
      Get.snackbar("Error", error.toString());
    });

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  void deleteOrganizer(String id, String name) {
    Get.defaultDialog(
        title: "Delete Organizer",
        content: RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                children: [
              WidgetSpan(
                  child: Center(
                child: Text(
                  "Are you sure to delete organizer ",
                  textAlign: TextAlign.center,
                ),
              )),
              WidgetSpan(
                  child: Center(
                child: Text(
                  "\"$name\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ])),
        textConfirm: "Delete",
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          await organizersRef.doc(id).delete();
          Get.snackbar("Alert", "Organizer \"$name\" deleted");
        },
        textCancel: "Cancel",
        onCancel: () {
          Get.back();
        });
  }

  List<Contest> getWonContests() {
    List<Contest> cons = [];
    for (var c in contestsList) {
      if (c.winner_id.isNotEmpty) {
        cons.add(c);
      }
    }
    return cons;
  }

  UserInfo? getUserById(String id) {
    for (var user in usersList.value) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  void getParticipants(String contest_id) {
    ticketsList.bindStream(participantsStream(contest_id));
  }
}
