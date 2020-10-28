import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key key,
    this.name,
    this.lastMessage,
    this.profilePic,
    this.onPress,
    this.lastActivity,
    this.isRead,
  }) : super(key: key);

  final String name, lastMessage;
  final String profilePic;
  final Function onPress;
  final bool isRead;
  final String lastActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            onTap: onPress,
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 28,
              backgroundImage: NetworkImage(profilePic),
            ),
            title: Text(
              name,
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
                Text(lastActivity),
                Icon(isRead ? Icons.done_all : Icons.done),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
