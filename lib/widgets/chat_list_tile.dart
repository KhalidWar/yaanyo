import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/chat_room_screen.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key key,
    this.userName,
    this.lastMessage,
    this.chatRoomID,
    this.currentUserEmail,
    this.profilePic,
  }) : super(key: key);

  final String userName, profilePic, lastMessage, chatRoomID, currentUserEmail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 28,
              backgroundImage: NetworkImage(profilePic),
            ),
            title: Text(
              userName,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              lastMessage,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.done_all),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChatRoomScreen(
                    name: userName,
                    chatRoomID: chatRoomID,
                    currentUserEmail: currentUserEmail,
                  );
                },
              ));
            },
          ),
        ),
      ],
    );
  }
}
