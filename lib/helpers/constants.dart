import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fenua_contests/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/shared_user.dart';

bool userSignedIn = false;
late String userMail;
String appName = LocaleKeys.appName.tr;
String googleAPIKey = "AIzaSyCp2I8VzxRNn4ls-1bPs1eGJDYDqxcimEM";
String test_image =
    "https://static.wikia.nocookie.net/mrbean/images/4/4b/Mr_beans_holiday_ver2.jpg/revision/latest?cb=20181130033425";

CollectionReference organizersRef =
    FirebaseFirestore.instance.collection("organizers");
CollectionReference contestsRef =
    FirebaseFirestore.instance.collection("contests");
CollectionReference usersRef = FirebaseFirestore.instance.collection("users");

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  final snackBar = new SnackBar(
    content: Text(message),
    backgroundColor: Color(0xFF505050),
    behavior: SnackBarBehavior.floating,
  );
  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

void openScreen(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void closeAllScreens(BuildContext context) {
  Navigator.popUntil(context, (route) => false);
}

bool isPhoneValid(String phone, BuildContext context, String country_code) {
  if (country_code.isEmpty) {
    showSnackBar("Re-select your phone country", context);
    return false;
  }
  if (phone.startsWith("0")) {
    showSnackBar("Do not include first 0 with in phone number", context);
    return false;
  } else if (phone.length != 10 || !phone.startsWith("3")) {
    showSnackBar("Enter valid phone number", context);
    return false;
  }

  return true;
}

void showModalBottomSheetMenu(
    {required BuildContext context,
    required Widget content,
    double? height,
    Color? backgroundColor}) {
  ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)));

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: backgroundColor ?? Colors.white,
      shape: shape,
      builder: (context) {
        return Wrap(
          spacing: 10,
          children: [
            AppBar(
              centerTitle: true,
              shape: shape,
              title: Container(
                child: Icon(
                  Icons.horizontal_rule_rounded,
                  color: Colors.grey,
                  size: 100,
                ),
              ),
              backgroundColor: backgroundColor ?? Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false, // remove back button in appbar.
            ),
            Container(child: content),
            // Container(
            //   height: height,
            //   child: Column(
            //     children: [
            //       Container(
            //           height: 50,
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.only(
            //                   topLeft: Radius.circular(50),
            //                   topRight: Radius.circular(50))),
            //           child: Align(
            //             alignment: Alignment.center,
            //             child: content,
            //           )),
            //     ],
            //   ),
            // )
          ],
        );
      });
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Future<DateTime> selectDate(
    BuildContext context, int startTimestamp, int? selectedTimestamp) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(
          selectedTimestamp ?? startTimestamp),
      firstDate: DateTime.fromMillisecondsSinceEpoch(startTimestamp),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) selectedDate = picked;

  return selectedDate;
}

void saveSharedPref(SharedUser user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("id", user.id);
  prefs.setString("name", user.name);
  prefs.setString("type", user.userType);
}

Future<SharedUser> getUserFromSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return SharedUser(
    id: prefs.getString("id") ?? "",
    name: prefs.getString("name") ?? "",
    userType: prefs.getString("type") ?? "",
  );
}

Future<void> logoutSharedUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("id", "");
  prefs.setString("name", "");
  prefs.setString("type", "");
}

String timestampToDateFormat(int timestamp, String format) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat(format).format(dateTime);
}

void showOptionsBottomSheet(
    {required BuildContext context,
    required Text title,
    required List<ListTile> options}) {
  List<Widget> optionsWithTitle = [];
  optionsWithTitle.add(Padding(
    padding: const EdgeInsets.all(8.0),
    child: title,
  ));
  optionsWithTitle.addAll(options);
  optionsWithTitle.add(ListTile());
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: optionsWithTitle,
        );
      });
}
String convertTimeToText(String prefix, int timestamp, String suffix) {
  String convTime = "";

  try {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    int second = dateTime1.difference(dateTime2).inSeconds;
    int minute = dateTime1.difference(dateTime2).inMinutes;
    int hour = dateTime1.difference(dateTime2).inHours;
    int day = dateTime1.difference(dateTime2).inDays;

    if (second < 60) {
      convTime = "$prefix ${second} secs $suffix";
    } else if (minute < 60) {
      convTime = "$prefix ${minute} mins $suffix";
    } else if (hour < 24) {
      convTime = "$prefix ${hour} hrs $suffix";
    } else if (day >= 7) {
      if (day > 360) {
        convTime = "$prefix ${day ~/ 360} yrs $suffix";
      } else if (day > 30) {
        convTime = "$prefix ${day ~/ 30} mons $suffix";
      } else {
        convTime = "$prefix ${day ~/ 7} weeks $suffix";
      }
    } else if (day < 7) {
      convTime = "$prefix ${day} days $suffix";
    }
  } catch (e) {
    print(e.toString() + "------");
  }

  return convTime;
}
void launchUrl(String url) async {
  if (await canLaunch(url)) {
    launch(
        url,
        forceSafariVC: true,
        enableJavaScript: true,
        forceWebView: true
    );
  } else {
    throw 'Could not launch $url';
  }
}