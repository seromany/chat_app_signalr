class ChatScreenData {
  bool isGroup;
  int? chatUserId;
  String chatTitle;

  ChatScreenData(
      {required this.isGroup, required this.chatTitle, this.chatUserId});
}
