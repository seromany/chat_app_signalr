import 'package:chat_app_signalr/Controllers/hub_controller.dart';
import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Models/user.dart';
import 'package:chat_app_signalr/datas/app_color.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:chat_app_signalr/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dialogs {
  static Future<void> defaultDialog({required Widget content}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          content: content,
        );
      },
    );
  }

  static Future<void> infoDialog(Icon? infoIcon, {required String infoText}) {
    return defaultDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (infoIcon != null) infoIcon,
        Text(infoText),
        InkWell(
          onTap: () => Navigator.pop(navigatorKey.currentContext!),
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "Okay",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        )
      ],
    ));
  }

  static Future<void> logoutDialog() {
    return defaultDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.question_mark,
          color: AppColor.appPurple,
        ),
        Text("Are you sure you want to log out of the app?"),
        InkWell(
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, loginScreenRoute);
          },
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "Yes",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(navigatorKey.currentContext!),
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "No",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        )
      ],
    ));
  }

  static Future<void> selectPersonForGroup() {
    List<User> users = UserController().users;
    List<User> selectedUsers = [];
    return defaultDialog(content: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < users.length; i++) ...{
            Row(
              spacing: 10,
              children: [
                Checkbox(
                  checkColor: AppColor.appPurple,
                  value: selectedUsers
                      .where(
                        (element) => element.userId == users[i].userId,
                      )
                      .isNotEmpty,
                  onChanged: (bool? value) {
                    if (value != null) {
                      if (value) {
                        selectedUsers.add(users[i]);
                      } else {
                        selectedUsers.remove(users[i]);
                      }
                      setState(() {});
                    }
                  },
                ),
                CircleAvatar(
                    child: ClipOval(child: Image.asset("images/logo.png"))),
                Text(users[i].userName!)
              ],
            ),
            Divider(),
          },
          InkWell(
            onTap: () {
              UserController().setSelectedUsers(selectedUsers);
              Navigator.pop(navigatorKey.currentContext!);
            },
            hoverColor: AppColor.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.appPurple,
              ),
              margin: EdgeInsets.only(top: 10),
              width: 100,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                "Okay",
                style: TextStyle(color: AppColor.white),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(navigatorKey.currentContext!),
            hoverColor: AppColor.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.appPurple,
              ),
              margin: EdgeInsets.only(top: 10),
              width: 100,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColor.white),
              ),
            ),
          )
        ],
      );
    }));
  }

  static Future<void> addGroupDialog() {
    UserController().selectedUsers.clear();
    TextEditingController groupNameController = TextEditingController();
    return defaultDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: AppColor.appGray),
          child: TextField(
            controller: groupNameController,
            decoration: InputDecoration(hintText: "Group Name"),
          ),
        ),
        InkWell(
          onTap: () => selectPersonForGroup(),
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "Select Person",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            HubController().addGroup(
                groupName: groupNameController.text,
                groupUsers: UserController().selectedUsers);
            Navigator.pop(navigatorKey.currentContext!);
          },
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "Create",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(navigatorKey.currentContext!),
          hoverColor: AppColor.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.appPurple,
            ),
            margin: EdgeInsets.only(top: 10),
            width: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        )
      ],
    ));
  }
}
