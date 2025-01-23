import 'package:chat_app_signalr/Controllers/message_controller.dart';
import 'package:chat_app_signalr/Database/dss_db.dart';
import 'package:chat_app_signalr/Datas/app_color.dart';
import 'package:chat_app_signalr/Models/chat_screen_data.dart';
import 'package:chat_app_signalr/datas/router.dart';
import 'package:chat_app_signalr/main.dart';
import 'package:flutter/material.dart';

class ChatBoxWidget extends StatelessWidget {
  const ChatBoxWidget({
    super.key,
    required this.chatTitle,
    required this.chatText,
    this.imageUrl,
    required this.isGroup,
    this.chatUserId,
  });
  final String chatTitle;
  final String chatText;
  final String? imageUrl;
  final bool isGroup;
  final int? chatUserId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        MessageController().activeMessages.clear();
        if (isGroup) {
          var activeMessages =
              await DSSDB().getGroupMessages(groupName: chatTitle);
          MessageController().setActiveMessages(activeMessages);
        } else {
          var activeMessages =
              await DSSDB().getPersonMessages(messageReceiveId: chatUserId!);
          MessageController().setActiveMessages(activeMessages);
        }
        MessageController()
            .setActiveChat(chatUserId: chatUserId, chatGroupName: chatTitle);
        Navigator.pushNamed(navigatorKey.currentContext!, chatScreenRoute,
            arguments: ChatScreenData(
                isGroup: isGroup,
                chatTitle: chatTitle,
                chatUserId: chatUserId));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: AppColor.appGray, width: 2))),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          spacing: 10,
          children: [
            CircleAvatar(
                child: ClipOval(
                    child: imageUrl == null
                        ? Image.asset("images/logo.png")
                        : Image.network(imageUrl!))),
            Expanded(
              child: SizedBox(
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    text: TextSpan(
                        text: "$chatTitle\n",
                        style: TextStyle(
                            color: AppColor.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: chatText,
                              style: TextStyle(fontWeight: FontWeight.normal))
                        ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
