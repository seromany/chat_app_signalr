import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Datas/app_color.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:chat_app_signalr/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Image.asset(
                  "images/logo.png",
                  height: 100,
                ),
                containerTextfield("Username",
                    obscureText: false,
                    obscuringCharacter: '•',
                    usernameController: usernameController),
                containerTextfield("Şifre",
                    obscureText: true,
                    obscuringCharacter: '*',
                    usernameController: passwordController),
                TextButton(onPressed: () {}, child: Text("Forgat Password")),
                containerButton(
                    onTap: () => UserController().login(
                        userName: usernameController.text,
                        userPassword: passwordController.text),
                    containerColor: AppColor.appPurple,
                    text: "Login",
                    textColor: AppColor.white),
                containerButton(
                    onTap: () => Navigator.pushReplacementNamed(
                        navigatorKey.currentContext!, registerScreenRoute),
                    containerColor: AppColor.appPurple,
                    text: "Register",
                    textColor: AppColor.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell containerButton(
      {required void Function() onTap,
      required Color containerColor,
      required Color textColor,
      required String text}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: containerColor),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container containerTextfield(String? hintText,
      {required bool obscureText,
      required String obscuringCharacter,
      required TextEditingController usernameController}) {
    final containerDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: AppColor.appGray);
    return Container(
        decoration: containerDecoration,
        child: TextField(
          controller: usernameController,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          decoration: InputDecoration(hintText: hintText),
          style: TextStyle(color: AppColor.black),
        ));
  }
}
