import 'dart:convert';
import 'package:chat_app_signalr/Controllers/api_controller.dart';
import 'package:chat_app_signalr/Controllers/hub_controller.dart';
import 'package:chat_app_signalr/Models/Group.dart';
import 'package:chat_app_signalr/Models/user.dart';
import 'package:chat_app_signalr/datas/app_color.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:chat_app_signalr/main.dart';
import 'package:chat_app_signalr/widgets/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();

  factory UserController() {
    return _instance;
  }

  UserController._internal() {
    _dio = Dio();
    _users = [];
    _selectedUsers = [];
    _activeUser = User();
    _controllerName = "api/User";
  }

  late Dio _dio;
  late String _controllerName;
  late List<User> _users;
  late List<User> _selectedUsers;
  late User _activeUser;

  String get controllerName => _controllerName;
  Dio get dio => _dio;
  List<User> get users => _users;
  List<User> get selectedUsers => _selectedUsers;
  User get activeUser => _activeUser;

  Future<bool> getUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      final int userId = prefs.getInt("userId")!;
      if (token != null) {
        final response = await dio.get(
            '${ApiController.baseurl}$controllerName/GetUser',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
            queryParameters: {"userId": userId});

        if (response.statusCode == 200) {
          _activeUser = User.fromJson(response.data["payload"]);
          return true;
        }
      }
    } catch (e) {
      Dialogs.infoDialog(
          Icon(
            Icons.error,
            color: AppColor.appRed,
          ),
          infoText: "Login status error: $e");
    }
    return false;
  }

  Future<bool> loginStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      if (token != null) {
        final response = await dio.get(
            '${ApiController.baseurl}$controllerName/LoginStatus',
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        if (response.statusCode == 200) {
          return true;
        }
      }
    } catch (e) {
      Dialogs.infoDialog(
          Icon(
            Icons.error,
            color: AppColor.appRed,
          ),
          infoText: "Login status error: $e");
    }
    return false;
  }

  Future<void> login(
      {required String userName, required String userPassword}) async {
    try {
      final response = await dio.post(
        '${ApiController.baseurl}$controllerName/Login',
        data: jsonEncode(User(
            userId: 0,
            userName: userName,
            userPassword: userPassword,
            userActive: true)),
        //options: Options(contentType: Headers.jsonContentType)
      );
      if (response.statusCode == 200) {
        if (!response.data["hasError"]) {
          var payload = response.data["payload"];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", payload["token"]);
          _activeUser = User.fromJson(payload["user"]);
          prefs.setInt("userId", activeUser.userId!);
          HubController().hubConnectionStart();
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, mainScreenRoute);
          return;
        } else {
          Dialogs.infoDialog(
              Icon(
                Icons.error,
                color: AppColor.appRed,
              ),
              infoText: "Server error: ${response.data["errorText"]}");
        }
      } else {
        Dialogs.infoDialog(
            Icon(
              Icons.error,
              color: AppColor.appRed,
            ),
            infoText: "Response status code error: ${response.statusCode}");
      }
    } catch (e) {
      Dialogs.infoDialog(
          Icon(
            Icons.error,
            color: AppColor.appRed,
          ),
          infoText: "Error: $e");
    }
  }

  Future<void> register(
      {required String userName, required String userPassword}) async {
    try {
      final response = await dio.post(
        '${ApiController.baseurl}$controllerName/Register',
        data: jsonEncode(User(
            userId: 0,
            userName: userName,
            userPassword: userPassword,
            userActive: true)),
        //options: Options(contentType: Headers.jsonContentType)
      );
      if (response.statusCode == 200) {
        if (!response.data["hasError"]) {
          Dialogs.infoDialog(
              Icon(
                Icons.check,
                color: AppColor.appPurple,
              ),
              infoText: "User created");
          /*await Future.delayed(Duration(seconds: 2));
          Navigator.pop(navigatorKey.currentContext!);*/
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, loginScreenRoute);
          return;
        } else {
          Dialogs.infoDialog(
              Icon(
                Icons.error,
                color: AppColor.appRed,
              ),
              infoText: "Server error: ${response.data["errorText"]}");
        }
      } else {
        Dialogs.infoDialog(
            Icon(
              Icons.error,
              color: AppColor.appRed,
            ),
            infoText: "Response status code error: ${response.statusCode}");
      }
    } catch (e) {
      Dialogs.infoDialog(
          Icon(
            Icons.error,
            color: AppColor.appRed,
          ),
          infoText: "Error: $e");
    }
  }

  void setSelectedUsers(List<User> selectUsers) {
    selectedUsers.addAll(selectUsers);
  }

  void setUsers(List<User> socketUsers) {
    users.clear();
    users.addAll(socketUsers);
    notifyListeners();
  }

  void setActiveUserGroups(List<Group> groups) {
    activeUser.groups!.addAll(groups);
    notifyListeners();
  }

  String getUsername(int userId) {
    if (userId == activeUser.userId) {
      return activeUser.userName!;
    }
    return users
        .firstWhere(
          (element) => element.userId == userId,
        )
        .userName!;
  }
}
