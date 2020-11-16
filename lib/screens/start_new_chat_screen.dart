import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/screens/chat_room_screen.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';
import 'package:yaanyo/widgets/error_text.dart';

class StartNewChatScreen extends StatefulWidget {
  const StartNewChatScreen({Key key}) : super(key: key);

  @override
  _StartNewChatScreenState createState() => _StartNewChatScreenState();
}

class _StartNewChatScreenState extends State<StartNewChatScreen> {
  final DatabaseService _databaseService = serviceLocator<DatabaseService>();
  final TextEditingController _textEditingController = TextEditingController();

  QuerySnapshot _searchSnapshot;
  QuerySnapshot currentUserSnapshot;
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

  void createChatRoom({Map<String, dynamic> searchedUserData}) async {
    String getChatRoomID(String a, String b) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return '$b\_$a';
      } else {
        return '$a\_$b';
      }
    }

    final currentUser = AppUser.fromJson(currentUserSnapshot.docs[0].data());
    final searchedUser = AppUser.fromJson(searchedUserData);

    if (searchedUser.email == currentUser.email) {
      setState(() {
        _error = 'You cannot chat with yourself';
      });
    } else {
      List<Map<String, dynamic>> users = [
        currentUser.toJson(),
        searchedUser.toJson(),
      ];

      String chatRoomID = getChatRoomID(searchedUser.email, currentUser.email);

      Map<String, Object> chatRoomMap = {
        'users': users,
        'chatRoomID': chatRoomID,
        'emails': [currentUser.email, searchedUser.email]
      };

      _databaseService.createChatRoom(chatRoomID, chatRoomMap);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoomScreen(
                    name: searchedUser.name,
                    email: searchedUser.email,
                    profilePic: searchedUser.profilePic,
                    chatRoomID: chatRoomID,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    _databaseService
        .searchUserByEmail(FirebaseAuth.instance.currentUser.email)
        .then((value) {
      setState(() {
        currentUserSnapshot = value;
      });
    });
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
                          final data = _searchSnapshot.docs[index].data();
                          return GestureDetector(
                            onTap: () => createChatRoom(searchedUserData: data),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic'])),
                              title: Text(data['name']),
                              subtitle: Text(data['email']),
                              trailing: Icon(Icons.send),
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
