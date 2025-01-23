import 'package:chat_app_signalr/Controllers/hub_controller.dart';
import 'package:chat_app_signalr/Controllers/message_controller.dart';
import 'package:chat_app_signalr/Controllers/user_controller.dart';
import 'package:chat_app_signalr/Datas/app_color.dart';
import 'package:chat_app_signalr/Models/chat_screen_data.dart';
import 'package:chat_app_signalr/Models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.screenData});
  final ChatScreenData screenData;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  messageSend(value) {
    HubController().sendMessage(
        message: Message(
            messageGroupName: widget.screenData.chatTitle,
            messageOwnerId: UserController().activeUser.userId,
            messageReceiveId: widget.screenData.chatUserId,
            messageText: value));
    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.appMessagePurple,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(
              child: ClipOval(child: Image.asset("images/logo.png"))),
        ),
        title: Text(
          widget.screenData.chatTitle,
          style: TextStyle(color: AppColor.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: ChangeNotifierProvider.value(
                    value: MessageController(),
                    child: Consumer<MessageController>(
                        builder: (context, value, child) {
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: value.activeMessages.length,
                        itemBuilder: (_, i) =>
                            userMessageBox(value.activeMessages[i]),
                      );
                    }))),
            chatScreenEventWidget()
          ],
        ),
      ),
    );
  }

  Container userMessageBox(Message message) {
    bool isOwner = message.messageOwnerId == UserController().activeUser.userId;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            !isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwner) ...{
            CircleAvatar(child: ClipOval(child: Image.asset("images/logo.png")))
          },
          Container(
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: !isOwner ? AppColor.appMessagePurple : AppColor.appPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                    text: TextSpan(
                        text: UserController()
                            .getUsername(message.messageOwnerId!),
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        children: [
                      TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: AppColor.white),
                          text: "\n${message.messageText}"),
                    ])),
                Text(
                  MessageController().getMessageDate(message: message),
                  style: TextStyle(fontSize: 12, color: AppColor.white),
                ),
              ],
            ),
          ),
          if (isOwner) ...{
            CircleAvatar(child: ClipOval(child: Image.asset("images/logo.png")))
          }
        ],
      ),
    );
  }

  Container chatScreenEventWidget() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.appGray,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 5,
        children: [
          Expanded(
              child: TextField(
            controller: messageController,
            minLines: 1,
            maxLines: 5,
          )),
          Container(
            decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(width: 2, color: AppColor.black))),
            child: IconButton(
                onPressed: () => messageSend(messageController.text),
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppColor.appMessagePurple,
                )),
          )
        ],
      ),
    );
  }
}
