import 'package:chat_app_signalr/Database/database_service.dart';
import 'package:chat_app_signalr/Models/message.dart';
import 'package:sqflite/sqflite.dart';

class DSSDB {
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS Messages (
      "messageOwnerId" INTEGER NOT NULL,
      "messageReceiveId" INTEGER,
      "messageGroupName" TEXT,
      "messageText" TEXT,
      "messageDate" INTEGER
    ) """);
  }

  Future insertMessage(Message message) async {
    try {
      final database = await DatabaseService().database;
      String queryText =
          """Insert INTO Messages VALUES (${message.messageOwnerId}, ${message.messageReceiveId}, '${message.messageGroupName}', '${message.messageText}',${message.messageDate})""";
      await database.rawQuery(queryText);
    } catch (e) {
      //print("SQFLite error => $e");
    }
  }

  Future<Message> getGroupLastMessage({required String groupName}) async {
    try {
      final database = await DatabaseService().database;
      var resultMessages = await database.rawQuery(
          ''' SELECT * FROM Messages WHERE messageGroupName = ? ORDER BY messageDate DESC LIMIT 1''',
          [groupName]);
      if (resultMessages.isEmpty) {
        return Message(
            messageGroupName: groupName,
            messageOwnerId: 0,
            messageDate: 1619451874928,
            messageText: "Goup Created");
      }
      return Message.fromJsonApi(resultMessages[0]);
    } catch (e) {
      //print("getGroupMessages error => $e");
      return Message(
          messageGroupName: groupName,
          messageDate: 1619451874928,
          messageText: "Get message error!");
    }
  }

  Future<Message> getPersonLastMessage({required int messageReceiveId}) async {
    try {
      final database = await DatabaseService().database;
      var resultMessages = await database.rawQuery(
          ''' SELECT * FROM Messages WHERE messageReceiveId = ? OR messageOwnerId = ? AND messageGroupName = NULL  ORDER BY messageDate DESC LIMIT 1''',
          [messageReceiveId, messageReceiveId]);
      if (resultMessages.isEmpty) {
        return Message(
            messageOwnerId: 0,
            messageDate: 1619451874928,
            messageReceiveId: messageReceiveId,
            messageText: "Write a message to your friend now...");
      }
      return Message.fromJsonApi(resultMessages[0]);
    } catch (e) {
      //print("getPersonMessages error => $e");
      return Message(
          messageReceiveId: messageReceiveId,
          messageDate: 1619451874928,
          messageText: "Get message error!");
    }
  }

  Future<List<Message>> getGroupMessages({required String groupName}) async {
    try {
      final database = await DatabaseService().database;
      var resultMessages = await database.rawQuery(
          ''' SELECT * FROM Messages WHERE messageGroupName = ? ORDER BY messageDate DESC''',
          [groupName]);
      return (resultMessages as List)
          .map(
            (e) => Message.fromJsonApi(e),
          )
          .toList();
    } catch (e) {
      //print("getGroupMessages eerror => $e");
      return [];
    }
  }

  Future<List<Message>> getPersonMessages(
      {required int messageReceiveId}) async {
    try {
      final database = await DatabaseService().database;
      var resultMessages = await database.rawQuery(
          ''' SELECT * FROM Messages WHERE messageReceiveId = ? OR messageOwnerId = ? ORDER BY messageDate DESC''',
          [messageReceiveId, messageReceiveId]);
      return (resultMessages as List)
          .map(
            (e) => Message.fromJsonApi(e),
          )
          .toList();
    } catch (e) {
      //print("getPersonMessages eerror => $e");
      return [];
    }
  }
}
