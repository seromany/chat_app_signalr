import 'package:chat_app_signalr/Controllers/hub_controller.dart';
import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:chat_app_signalr/main.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  isLogin() async {
    bool result = await UserController().loginStatus();
    if (result) {
      bool resultUser = await UserController().getUser();
      if (resultUser) {
        HubController().hubConnectionStart();
        Navigator.pushReplacementNamed(
            navigatorKey.currentContext!, mainScreenRoute);
      } else {
        Navigator.pushReplacementNamed(
            navigatorKey.currentContext!, loginScreenRoute);
      }
    } else {
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, loginScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset(
            "images/logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
