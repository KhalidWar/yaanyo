import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/services/database/chat_database_service.dart';
import 'package:yaanyo/utilities/confirmation_dialog.dart';
import 'package:yaanyo/widgets/alert_widget.dart';
import 'package:yaanyo/widgets/chat_list_tile.dart';
import 'package:yaanyo/widgets/fab_open_container.dart';

import '../../constants.dart';
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

  String _lastMessage;

  @override
  void initState() {
    super.initState();
    _chatStream = _chatDBService.getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FABOpenContainer(
          heroTag: 'chatTab',
          iconData: Icons.chat,
          child: StartNewChatScreen()),
      body: StreamBuilder(
        stream: _chatStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return AlertWidget(
                  lottie: kLottieErrorCone, label: kSomethingWentWrong);
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.data.documents.isEmpty) {
                return AlertWidget(lottie: 'assets/lottie/booGhost.json');
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
                      _lastMessage = value;
                    });

                    return ChatListTile(
                      userName: name,
                      profilePic: profilePic,
                      lastMessage: _lastMessage ?? '...',
                      index: index,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(
                              name: name,
                              email: email,
                              profilePic: profilePic,
                              chatRoomID: data['chatRoomID'],
                              index: index,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return AlertWidget(
                  iconData: Icons.warning_amber_rounded,
                  label: 'Something went wrong\n${snapshot.error}',
                  buttonLabel: 'Sign out',
                  buttonOnPress: () => ConfirmationDialogs().signOut(context),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }
}
