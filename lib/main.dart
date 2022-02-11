import 'package:admob_flutter/admob_flutter.dart';
import 'package:fenua_contests/views/screens/screen_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helpers/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA_VZhJ9vvap-1rXthjnw8l8KywcBEPxrA",
        appId: "1:143330305301:web:dae56d18b929d875ba351c",
        messagingSenderId: "143330305301",
        projectId: "fenua-contests",
        storageBucket: "gs://fenua-contests.appspot.com/"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await Admob.initialize();
  if (GetPlatform.isIOS) {
    await Admob.requestTrackingAuthorization();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fenua Contests',
      home: RegistrationScreen(),
      theme: ThemeData(
        fontFamily: 'Metropolis',
        primarySwatch: appPrimaryColor,
      ),
    );
  }
}
