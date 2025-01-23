import 'package:chat_app_signalr/Controllers/message_controller.dart';
import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Datas/app_color.dart';
import 'package:chat_app_signalr/Models/Group.dart';
import 'package:chat_app_signalr/Models/user.dart';
import 'package:chat_app_signalr/widgets/chatbox_widget.dart';
import 'package:chat_app_signalr/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      floatingActionButton: InkWell(
        onTap: () => Dialogs.addGroupDialog(),
        child: Container(
          width: 55,
          height: 55,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColor.appPurple),
          child: Text(
            "+",
            style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.w900,
                fontSize: 25),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColor.white,
        leadingWidth: double.maxFinite,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                      Icons.search,
                      color: AppColor.appGray,
                    )),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Dialogs.logoutDialog(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 27,
                    color: AppColor.appPurple,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          height: double.maxFinite,
          width: double.maxFinite,
          child: ChangeNotifierProvider.value(
              value: UserController(),
              child: Consumer<UserController>(builder: (context, value, child) {
                List<User> chatUsers = value.users;
                chatUsers.removeWhere(
                  (element) => element.userId == value.activeUser.userId,
                );
                List<Group> chatGroups = value.activeUser.groups!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 5,
                    children: [
                      for (var i = 0; i < chatUsers.length; i++) ...{
                        FutureBuilder<String>(
                          future: MessageController().getPersonLastMessage(
                              messageReceiveId:
                                  chatUsers[i].userId!), // async work
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return ChatBoxWidget(
                                  chatText: "Loading...",
                                  chatTitle: chatUsers[i].userName!,
                                  imageUrl: null,
                                  isGroup: false,
                                  chatUserId: chatUsers[i].userId,
                                );
                              default:
                                if (snapshot.hasError) {
                                  return ChatBoxWidget(
                                    chatText: "Massage load failed",
                                    chatTitle: chatUsers[i].userName!,
                                    imageUrl: null,
                                    isGroup: false,
                                    chatUserId: chatUsers[i].userId,
                                  );
                                } else {
                                  return ChatBoxWidget(
                                    chatText: snapshot.data!,
                                    chatTitle: chatUsers[i].userName!,
                                    imageUrl: null,
                                    isGroup: false,
                                    chatUserId: chatUsers[i].userId,
                                  );
                                }
                            }
                          },
                        )
                      },
                      for (var i = 0; i < chatGroups.length; i++) ...{
                        FutureBuilder<String>(
                          future: MessageController().getPersonLastMessage(
                              messageReceiveId:
                                  chatUsers[i].userId!), // async work
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return ChatBoxWidget(
                                  chatText: "Loading...",
                                  chatTitle: chatUsers[i].userName!,
                                  imageUrl: null,
                                  isGroup: false,
                                  chatUserId: chatUsers[i].userId,
                                );
                              default:
                                if (snapshot.hasError) {
                                  return ChatBoxWidget(
                                    chatText: "Message load failed",
                                    chatTitle: chatUsers[i].userName!,
                                    imageUrl: null,
                                    isGroup: false,
                                    chatUserId: chatUsers[i].userId,
                                  );
                                } else {
                                  return ChatBoxWidget(
                                    chatText: snapshot.data!,
                                    chatTitle: chatGroups[i].groupName!,
                                    imageUrl: null,
                                    isGroup: true,
                                  );
                                }
                            }
                          },
                        )
                      }
                    ],
                  ),
                );
              }))),
    );
  }
}
