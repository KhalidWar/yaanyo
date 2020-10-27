import 'package:flutter/material.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/chat_window.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'FAB2',
        child: Icon(Icons.chat),
        onPressed: () {},
      ),
      body: ChatListTile(
        name: 'Joe Doe',
        lastMessage: 'Yea, that\'s a good idea',
        onPress: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ChatWindow();
            },
          ));
        },
      ),
    );
  }
}
