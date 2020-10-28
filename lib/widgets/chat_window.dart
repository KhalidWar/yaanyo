import 'package:flutter/material.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({
    Key key,
    this.name,
    this.profilePic,
  }) : super(key: key);

  final String name, profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePic),
          ),
          SizedBox(width: 10),
          Text(name),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {},
        ),
      ],
    );
  }
}
