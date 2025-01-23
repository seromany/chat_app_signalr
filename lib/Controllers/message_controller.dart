import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Database/dss_db.dart';
import 'package:chat_app_signalr/Models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageController extends ChangeNotifier {
  static final MessageController _instance = MessageController._internal();

  factory MessageController() {
    return _instance;
  }

  MessageController._internal() {
    _activeMessages = [];
    _activeChatUserId = null;
    _activeChatGroupName = null;
  }

  late List<Message> _activeMessages;
  late int? _activeChatUserId;
  late String? _activeChatGroupName;

  List<Message> get activeMessages => _activeMessages;
  int? get activeChatUserId => _activeChatUserId;
  String? get activeChatGroupName => _activeChatGroupName;

  void setActiveChat(
      {required int? chatUserId, required String? chatGroupName}) {
    _activeChatUserId = chatUserId;
    _activeChatGroupName = chatGroupName;
  }

  void setActiveMessages(List<Message> messages) {
    activeMessages.addAll(messages);
    notifyListeners();
  }

  Future<String> getPersonLastMessage({required int messageReceiveId}) async {
    Message returnMessage =
        await DSSDB().getPersonLastMessage(messageReceiveId: messageReceiveId);
    return returnMessage.messageText!;
  }

  Future<String> getGroupLastMessage({required Message message}) async {
    Message returnMessage =
        await DSSDB().getGroupLastMessage(groupName: message.messageGroupName!);
    return returnMessage.messageText!;
  }

  String getMessageDate({required Message message}) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(message.messageDate!);
    return DateFormat("HH:mm").format(dateTime);
  }

  void addActiveMessages(Message message) async {
    await DSSDB().insertMessage(message);
    bool condition1 = (activeChatUserId != null &&
        message.messageOwnerId == UserController().activeUser.userId &&
        message.messageReceiveId == activeChatUserId);
    bool condition2 = (activeChatUserId != null &&
        message.messageOwnerId == activeChatUserId &&
        message.messageReceiveId == UserController().activeUser.userId);
    bool condition3 = message.messageGroupName == activeChatGroupName;
    if (condition1 || condition2 || condition3) {
      activeMessages.insert(0, message);
    }
    notifyListeners();
  }
}
