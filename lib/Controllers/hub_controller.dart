import 'package:chat_app_signalr/Controllers/api_controller.dart';
import 'package:chat_app_signalr/Controllers/message_controller.dart';
import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Models/Group.dart';
import 'package:chat_app_signalr/Models/message.dart';
import 'package:chat_app_signalr/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';

class HubController {
  static final HubController _instance = HubController._internal();

  factory HubController() {
    return _instance;
  }

  HubController._internal() {
    _connectionId = "";
  }

  late HubConnection _connection;
  late String _connectionId;

  HubConnection get connection => _connection;
  String get connectionId => _connectionId;

  void hubConnectionStart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    _connection = HubConnectionBuilder()
        .withAutomaticReconnect()
        .withUrl("${ApiController.baseurl}chatHub",
            options: HttpConnectionOptions(
              //logging: (level, message) => print(message),
              accessTokenFactory: () async => token,
            ))
        .build();

    await connection.start()!.then(
      (value) {
        _connectionId = connection.connectionId!;
        sendFirebaseToken();
      },
    ).onError(
      (error, stackTrace) async {
        hubConnectionStart();
      },
    );

    connection.onreconnecting(
      ({error}) {
        //print("reconnecting error => $error");
      },
    );

    connection.onreconnected(
      ({connectionId}) {
        _connectionId = connectionId!;
        //print("Connected Again => $connectionId");
      },
    );

    connection.onclose(
      ({error}) {
        hubConnectionStart();
      },
    );

    connection.on('allActiveUsers', (message) {
      UserController().setUsers((message![0] as List)
          .map(
            (e) => User.fromJson(e),
          )
          .toList());
    });

    connection.on('AddGroup', (message) {
      UserController().setActiveUserGroups(
          [Group.fromJson(message![0] as Map<String, dynamic>)]);
    });

    connection.on('receiveMessage', (message) {
      MessageController().addActiveMessages(
          Message.fromJson(message![0] as Map<String, dynamic>));
    });
  }

  void addGroup(
      {required String groupName, required List<User> groupUsers}) async {
    await connection.invoke('AddGroup', args: [groupName, groupUsers]);
  }

  void sendMessage({required Message message}) async {
    await connection.invoke('sendMessage', args: [message]);
  }

  void sendFirebaseToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var firebaseToken = prefs.getString("firebaseToken") ?? "";
    await connection.invoke('sendFirebaseToken', args: [firebaseToken]);
  }
}
