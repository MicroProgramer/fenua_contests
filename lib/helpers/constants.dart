import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shared_user.dart';

bool userSignedIn = false;
late String userMail;
String appName = "Contests App";
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
