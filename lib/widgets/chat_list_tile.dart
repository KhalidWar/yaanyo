import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key key,
    this.userName,
    this.lastMessage,
    this.profilePic,
    this.onPress,
  }) : super(key: key);

  final String userName, profilePic, lastMessage;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            onTap: onPress,
            leading: CircleAvatar(
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
          ),
        ),
      ],
    );
  }
}
