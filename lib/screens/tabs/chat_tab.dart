import 'package:flutter/material.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/chat_window.dart';

import '../start_new_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _chatLastActivity() {
    return '${DateTime.now().hour}:${DateTime.now().minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ChatListTile(
            name: 'Joe Doe',
            lastMessage: 'Yea, that\'s a good idea',
            lastActivity: _chatLastActivity(),
            profilePic:
                'https://images.unsplash.com/photo-1540854148606-26d095702211?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=08796a3910d0616a5381e7ccd1721279&auto=format&fit=crop&w=500&q=60',
            isRead: false,
            onPress: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChatWindow(
                    name: 'Joe Doe',
                    profilePic:
                        'https://images.unsplash.com/photo-1540854148606-26d095702211?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=08796a3910d0616a5381e7ccd1721279&auto=format&fit=crop&w=500&q=60',
                  );
                },
              ));
            },
          );
        },
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: 'FAB2',
      child: Icon(Icons.chat),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return StartNewChatScreen();
          },
        ));
      },
    );
  }
}
