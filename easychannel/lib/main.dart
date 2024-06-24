import 'package:easychannel/admin/AddDoctorScreen.dart';
import 'package:easychannel/admin/ViewAllAppointments.dart';
import 'package:easychannel/admin/nav.dart';
import 'package:easychannel/admin/view.dart';
import 'package:easychannel/firebase_options.dart';
import 'package:easychannel/user/DisplayDoctorsScreen.dart';
import 'package:easychannel/user/FindPharmaciesPage.dart';
import 'package:easychannel/user/SignUpScreen.dart';
import 'package:easychannel/user/bottomNavigationBar.dart';
import 'package:easychannel/user/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz; 

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
Firebase.initializeApp();

tz.initializeTimeZones(); 
 var initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_icon');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
