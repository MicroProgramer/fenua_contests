import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/helpers/constants.dart';
import 'package:fenua_contests/models/contest.dart';
import 'package:fenua_contests/models/organizer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
    update();
    return stream.map((querySnapshot) => querySnapshot.docs
        .map((doc) => Organizer.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Stream<List<Contest>> contestsStream() {
    Stream<QuerySnapshot> stream = contestsRef.snapshots();
    update();
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

  Organizer getOrganizerById(String id) {
    for (var organizer in organizersList) {
      if (organizer.id == id) {
        return organizer;
      }
    }

    return Organizer(id: "id", name: "name", image_url: "image_url");
  }

  Contest getContestById(String contest_id) {
    for (var c in contestsList) {
      if (c.id == contest_id) {
        return c;
      }
    }
    return Contest(
        id: contest_id,
        name: "Contest",
        images: [],
        description: "description",
        start_timestamp: 0,
        end_timestamp: 0,
        winner_id: "",
        organizer_id: "",
        show_participants_info: false);
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

  UserInfo getUserById(String id) {
    for (var user in usersList.value) {
      if (user.id == id) {
        return user;
      }
    }
    return UserInfo(
        first_name: "first_name",
        last_name: "last_name",
        nickname: "nickname",
        age: "age",
        city: "city",
        checked_0: false,
        checked_1: false,
        checked_2: false,
        id: id,
        email: "email",
        password: "password",
        phone: "phone",
        image_url: "image_url");
  }

  void getParticipants(String contest_id) {
    ticketsList.bindStream(participantsStream(contest_id));
  }

  Future<void> withdraw(String id) async {
    var rng = new Random();
    int winner_index = rng.nextInt(ticketsList.length);
    Ticket winner_ticket = ticketsList[winner_index];

    contestsRef
        .doc(id)
        .update({"winner_id": winner_ticket.user_id}).then((value) {
      UserInfo winner = getUserById(winner_ticket.user_id);
      return Get.snackbar("Success",
          winner.first_name + " " + winner.last_name + " won the contest");
    });
  }

  void emailWinner(UserInfo winner, String contestName) async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: '${winner.email}',
        query:
            'subject=Prize from $appName&body=Hi ${winner.first_name} ${winner.last_name}, You have won prize in $contestName and your prize is ................., ');

    var url = params.toString();
    if (await canLaunch(url)) {
      launch(
        url,
        forceSafariVC: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchMail(
      {required String toMailId,
      required String subject,
      required String body}) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
