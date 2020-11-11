import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/models/message.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';
import 'package:yaanyo/widgets/message_tile.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    Key key,
    this.name,
    this.profilePic,
    this.chatRoomID,
    this.email,
  }) : super(key: key);

  final String name, email, profilePic, chatRoomID;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _databaseService = serviceLocator<DatabaseService>();

  final TextEditingController _messageInputController = TextEditingController();

  Stream<QuerySnapshot> _chatMessageStream;

  void _sendMessage() async {
    if (_messageInputController.text.isNotEmpty) {
      final message = Message(
          message: _messageInputController.text,
          time: DateTime.now().millisecondsSinceEpoch,
          sender: _databaseService.currentUserEmail);
      await _databaseService.addMessage(widget.chatRoomID, message);
      _messageInputController.clear();
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
    _chatMessageStream = _databaseService.getChatMessages(widget.chatRoomID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatMessageStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return WarningWidget(
                        iconData: Icons.warning_amber_rounded,
                        label:
                            'No Internet Connection.\nPlease make sure you\'re online',
                        buttonLabel: 'Try again',
                        buttonOnPress: () {});
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          physics: BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data.documents[index].data();
                            return MessageTile(
                              message: data['message'],
                              sender: data['sender'] ==
                                  _databaseService.currentUserEmail,
                            );
                          });
                    } else if (snapshot.hasError) {
                      return WarningWidget(
                          iconData: Icons.warning_amber_rounded,
                          label: 'Something went wrong.\nPlease sign in again!',
                          buttonLabel: 'Try again',
                          buttonOnPress: () {});
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8, left: 8, bottom: 10, top: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.blue),
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
                  child: TextFormField(
                    controller: _messageInputController,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (value) => _sendMessage(),
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
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: ListTile(
        contentPadding: EdgeInsets.all(0),
        selected: false,
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.profilePic)),
        title: Text(widget.name, style: Theme.of(context).textTheme.headline6),
        subtitle: Text(widget.email),
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
