// ignore_for_file: file_names

class Group {
  String? groupName;

  Group({this.groupName});

  Group.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupName'] = groupName;
    return data;
  }
}
