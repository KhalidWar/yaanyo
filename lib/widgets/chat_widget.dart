import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key key,
    this.name,
    this.lastMessage,
    this.avatar,
    this.onPress,
  }) : super(key: key);

  final String name, lastMessage;
  final String avatar;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            onTap: onPress,
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              // radius: 26,
              //todo supply image
              // backgroundImage: ,
            ),
            title: Text(
              name,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              lastMessage,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      ],
    );
  }
}
