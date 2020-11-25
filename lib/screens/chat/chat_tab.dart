import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/services/database/chat_database_service.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

import 'chat_room_screen.dart';
import 'start_new_chat_screen.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _chatDBService = ChatDatabaseService();
  Stream<QuerySnapshot> _chatStream;

  String lastMessage;

  @override
  void initState() {
    super.initState();
    _chatStream = _chatDBService.getChatRooms();
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
                  buttonOnPress: () {});
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.data.documents.isEmpty) {
                return WarningWidget(
                    iconData: Icons.hourglass_empty,
                    label: 'Chat list is empty ',
                    buttonOnPress: () {});
              } else if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data.documents[index].data();
                    String name, email, profilePic;

                    if (data['users'][1]['email'] ==
                        FirebaseAuth.instance.currentUser.email) {
                      name = data['users'][0]['name'];
                      email = data['users'][0]['email'];
                      profilePic = data['users'][0]['profilePic'];
                    } else {
                      name = data['users'][1]['name'];
                      email = data['users'][1]['email'];
                      profilePic = data['users'][1]['profilePic'];
                    }

                    _chatDBService
                        .getLastMessage(data['chatRoomID'])
                        .then((value) {
                      lastMessage = value;
                    });

                    return ChatListTile(
                      userName: name,
                      profilePic: profilePic,
                      lastMessage: lastMessage ?? '...',
                      onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(
                                  name: name,
                                  email: email,
                                  profilePic: profilePic,
                                  chatRoomID: data['chatRoomID'],
                                )),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return WarningWidget(
                  iconData: Icons.warning_amber_rounded,
                  label: 'Something went wrong. \n Please sign in again!',
                  buttonLabel: 'Sign in again',
                  buttonOnPress: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen())),
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
            return StartNewChatScreen();
          },
        ));
      },
    );
  }
}
