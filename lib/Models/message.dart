class Message {
  int? messageOwnerId;
  int? messageReceiveId;
  String? messageGroupName;
  String? messageText;
  int? messageDate;

  Message(
      {this.messageOwnerId,
      this.messageReceiveId,
      this.messageGroupName,
      this.messageText,
      this.messageDate});

  Message.fromJson(Map<String, dynamic> json) {
    messageOwnerId = json['messageOwnerId'];
    messageReceiveId = json['messageReceiveId'];
    messageGroupName = json['messageGroupName'];
    messageText = json['messageText'];
    messageDate = DateTime.parse(json['messageDate']).millisecondsSinceEpoch;
  }

  Message.fromFirebaseJson(Map<String, dynamic> json) {
    messageOwnerId = int.parse(json['messageOwnerId']);
    messageReceiveId = int.parse(json['messageReceiveId']);
    messageGroupName = json['messageGroupName'];
    messageText = json['messageText'];
    messageDate = DateTime.parse(json['messageDate']).millisecondsSinceEpoch;
  }

  Message.fromJsonApi(Map<String, dynamic> json) {
    messageOwnerId = json['messageOwnerId'];
    messageReceiveId = json['messageReceiveId'];
    messageGroupName = json['messageGroupName'];
    messageText = json['messageText'];
    messageDate = json['messageDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageOwnerId'] = messageOwnerId;
    data['messageReceiveId'] = messageReceiveId;
    data['messageGroupName'] = messageGroupName;
    data['messageText'] = messageText;
    return data;
  }
}
