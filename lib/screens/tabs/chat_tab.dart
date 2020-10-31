import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

import '../start_new_chat_screen.dart';

class ChatTab extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatTab({Key key, this.currentUserEmail, this.currentUserName})
      : super(key: key);
  final String currentUserEmail;
  final String currentUserName;

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final DatabaseService _databaseService = DatabaseService();

  Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    Stream<QuerySnapshot> chatsStream =
        _databaseService.getChatRooms(widget.currentUserEmail);
    _chatStream = chatsStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: StreamBuilder(
        stream: _chatStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return WarningWidget(
                iconData: Icons.warning_amber_rounded,
                label:
                    'No Internet Connection \n Please make sure you\'re online',
                buttonLabel: 'Try again',
                buttonOnPress: () {},
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.data.documents.isEmpty) {
                return WarningWidget(
                  iconData: Icons.hourglass_empty,
                  label: 'Chat list is empty ',
                  buttonOnPress: () {},
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatListTile(
                      userName: snapshot.data.documents[index]
                          .data()['chatRoomID']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll('${widget.currentUserEmail}', ''),
                      profilePic:
                          snapshot.data.documents[index].data()['chatRoomID'],
                      lastMessage: 'Yea, that\'s a good idea',
                      chatRoomID:
                          snapshot.data.documents[index].data()['chatRoomID'],
                      currentUserEmail: widget.currentUserEmail,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return WarningWidget(
                  iconData: Icons.warning_amber_rounded,
                  label: 'Something went wrong. \n Please sign in again!',
                  buttonLabel: 'Sign in again',
                  buttonOnPress: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SignInScreen();
                    }));
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
          }
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
            return StartNewChatScreen(
              currentUserEmail: widget.currentUserEmail,
            );
          },
        ));
      },
    );
  }
}
