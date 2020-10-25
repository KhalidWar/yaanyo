import 'package:flutter/material.dart';
import 'package:yaanyo/widgets/chat_widget.dart';
import 'package:yaanyo/widgets/start_new_chat.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ChatWidget(
          name: 'Joe Doe',
          lastMessage: 'Yea, that\'s a good idea',
          onPress: () {},
        ),
        StartNewChat(
          onPress: () {},
        ),
      ],
    );
  }
}
