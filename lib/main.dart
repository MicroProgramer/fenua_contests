import 'package:admob_flutter/admob_flutter.dart';
import 'package:fenua_contests/views/screens/screen_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'generated/locales.g.dart';
import 'helpers/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD-buCds9z5qVw51TRMhEoSVSOtfno9cLE",
            authDomain: "jeux-concours-fenua.firebaseapp.com",
            projectId: "jeux-concours-fenua",
            storageBucket: "jeux-concours-fenua.appspot.com",
            messagingSenderId: "1012490138928",
            appId: "1:1012490138928:web:164baf8ec1e79cdc7104f5",
            measurementId: "G-SHQ69WGSB7"));
  } else {
    await Firebase.initializeApp();
  }
  await Admob.initialize();

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
      locale: Locale('fr', 'FR'),
      translationsKeys: AppTranslation.translations,
    );
  }
}
