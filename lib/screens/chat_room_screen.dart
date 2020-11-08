import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/models/message.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/widgets/message_tile.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    Key key,
    this.name,
    this.profilePic,
    this.chatRoomID,
    this.currentUserEmail,
  }) : super(key: key);

  final String name, profilePic, chatRoomID, currentUserEmail;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageInputController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  Stream _chatMessageStream;

  void _sendMessage() async {
    if (_messageInputController.text.isNotEmpty) {
      final message = Message(
          message: _messageInputController.text,
          time: DateTime.now().millisecondsSinceEpoch,
          sender: widget.currentUserEmail);
      await _databaseService.addMessage(widget.chatRoomID, message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Can not send empty message'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Stream<QuerySnapshot> conversationStream =
        _databaseService.getConversations(widget.chatRoomID);
    setState(() {
      _chatMessageStream = conversationStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: StreamBuilder(
                  stream: _chatMessageStream,
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
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MessageTile(
                                message: snapshot.data.documents[index]
                                    .data()['message'],
                                sentByMe: snapshot.data.documents[index]
                                        .data()['sendBy'] ==
                                    widget.currentUserEmail,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return WarningWidget(
                            iconData: Icons.warning_amber_rounded,
                            label:
                                'Something went wrong. \n Please sign in again!',
                            buttonLabel: 'Try again',
                            buttonOnPress: () {},
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                    }
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: <Widget>[
                    //todo open emoji keyboard
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageInputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          _sendMessage();
                          _messageInputController.clear();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message...',
                        ),
                      ),
                    ),
                    //todo access camera feed to capture photos
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _sendMessage();
                        _messageInputController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.profilePic)),
          SizedBox(width: 10),
          Text(widget.name),
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
