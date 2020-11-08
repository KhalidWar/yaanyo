import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/models/message.dart';

class Chat {
  const Chat({
    this.chatRoomID,
    this.message,
    this.users,
  });

  final String chatRoomID;
  final List<AppUser> users;
  final Message message;

  factory Chat.fromJson(
    Map<String, dynamic> json,
    Map<String, Object> jsonUsersList,
    Map<String, Object> jsonMessage,
  ) {
    List users = jsonUsersList['data'];
    List<AppUser> usersList = users.map((e) => AppUser.fromJson(e)).toList();

    final message = Message.fromJson(jsonMessage);

    return Chat(
      chatRoomID: json['data'],
      users: usersList,
      message: message,
    );
  }
}
