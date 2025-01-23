// ignore_for_file: file_names

import 'package:chat_app_signalr/Models/Group.dart';

class User {
  int? userId;
  String? userName;
  String? userPassword;
  String? connectionId;
  bool? userActive;
  List<Group>? groups;

  User(
      {this.userId,
      this.userName,
      this.userPassword,
      this.userActive,
      this.groups});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userPassword = json['userPassword'];
    connectionId = json['connectionId'];
    userActive = json['userActive'];
    if (json['groups'] != null) {
      groups = <Group>[];
      json['groups'].forEach((v) {
        groups!.add(Group.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['userPassword'] = userPassword;
    data['connectionId'] = connectionId;
    data['userActive'] = userActive;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
