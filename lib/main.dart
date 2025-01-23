import 'dart:io';
import 'package:chat_app_signalr/Datas/app_color.dart';
import 'package:chat_app_signalr/Notifications/firebase_api.dart';
import 'package:chat_app_signalr/datas/global_http.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              hoverColor: AppColor.transparent,
              border: InputBorder.none,
              filled: true,
              fillColor: AppColor.transparent),
          hoverColor: AppColor.transparent,
          splashColor: AppColor.transparent,
          highlightColor: AppColor.transparent),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: loadingScreenRoute,
    );
  }
}
