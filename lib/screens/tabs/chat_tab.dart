import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

import '../chat_room_screen.dart';
import '../start_new_chat_screen.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = serviceLocator<DatabaseService>().getChatRooms();
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
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data.documents[index].data();
                    return ChatListTile(
                      userName: data['users'][1]['name'],
                      profilePic: data['users'][1]['profilePic'],
                      lastMessage: 'Yea, that\'s a good idea',
                      onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(
                                  name: data['users'][1]['name'],
                                  email: data['users'][1]['email'],
                                  profilePic: data['users'][1]['profilePic'],
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
