import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/datas/app_color.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  String infoText = "";
  @override
  Widget build(BuildContext context) {
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
                containerTextfield("Password",
                    obscureText: true,
                    obscuringCharacter: '*',
                    usernameController: passwordController),
                containerTextfield("Password again",
                    obscureText: true,
                    obscuringCharacter: '*',
                    usernameController: passwordAgainController),
                Text(
                  infoText,
                  style: TextStyle(color: AppColor.appRed),
                ),
                containerButton(
                    onTap: () {
                      if (usernameController.text.trim() == "" ||
                          passwordController.text.trim() == "" ||
                          passwordAgainController.text.trim() == "") {
                        setState(() {
                          infoText =
                              "Username and Password fields can't be empty";
                        });
                        return;
                      }
                      if (passwordController.text !=
                          passwordAgainController.text) {
                        setState(() {
                          infoText = "Password fields do not match";
                        });
                        return;
                      }
                      UserController().register(
                          userName: usernameController.text,
                          userPassword: passwordAgainController.text);
                    },
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
