import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/chat_room_screen.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/widgets/error_text.dart';

class StartNewChatScreen extends StatefulWidget {
  const StartNewChatScreen({Key key, this.currentUserEmail}) : super(key: key);

  final String currentUserEmail;

  @override
  _StartNewChatScreenState createState() => _StartNewChatScreenState();
}

class _StartNewChatScreenState extends State<StartNewChatScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _textEditingController = TextEditingController();

  QuerySnapshot _searchSnapshot;
  String _error = '';

  void searchByEmailAddress() {
    if (_textEditingController.text.isEmpty || _textEditingController == null) {
      setState(() {
        _error = 'Search field cannot be empty';
      });
    } else {
      _databaseService.searchUserByEmail(_textEditingController.text).then(
        (value) {
          setState(() {
            _searchSnapshot = value;
            _error = '';
          });
        },
      );
    }
  }

  String _getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  void createChatRoom(
      {String searchedUserEmail, String profilePic, String name}) async {
    if (searchedUserEmail == widget.currentUserEmail) {
      setState(() {
        _error = 'You cannot chat with yourself';
      });
    } else {
      String chatRoomID =
          _getChatRoomID(searchedUserEmail, widget.currentUserEmail);

      List<String> users = [searchedUserEmail, widget.currentUserEmail];
      Map<String, dynamic> chatRoomMap = {
        'users  ': users,
        'chatRoomID': chatRoomID,
      };

      _databaseService.createChatRoom(chatRoomID, chatRoomMap);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ChatRoomScreen(
          name: name,
          profilePic: profilePic,
          chatRoomID: chatRoomID,
          currentUserEmail: widget.currentUserEmail,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Start New Chat')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.08,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) => searchByEmailAddress(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by email address',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchByEmailAddress();
                    },
                  ),
                ],
              ),
            ),
            _searchSnapshot == null
                ? ErrorText(error: _error)
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchSnapshot.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              createChatRoom(
                                name:
                                    _searchSnapshot.docs[index].data()['name'],
                                profilePic: _searchSnapshot.docs[index]
                                    .data()['profilePic'],
                                searchedUserEmail:
                                    _searchSnapshot.docs[index].data()['email'],
                              );
                            },
                            child: Container(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    _searchSnapshot.docs[index]
                                        .data()['profilePic'],
                                  ),
                                ),
                                title: Text(
                                    _searchSnapshot.docs[index].data()['name']),
                                subtitle: Text(_searchSnapshot.docs[index]
                                    .data()['email']),
                                trailing: Icon(Icons.send),
                              ),
                            ),
                          );
                        },
                      ),
                      ErrorText(error: _error)
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
