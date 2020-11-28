import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/constants.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/screens/chat/chat_room_screen.dart';
import 'package:yaanyo/services/database/chat_database_service.dart';
import 'package:yaanyo/services/database/user_database_service.dart';
import 'package:yaanyo/utilities/utilities.dart';
import 'package:yaanyo/widgets/error_text.dart';

class StartNewChatScreen extends StatefulWidget {
  const StartNewChatScreen({Key key}) : super(key: key);

  @override
  _StartNewChatScreenState createState() => _StartNewChatScreenState();
}

List<AppUser> _recentSearchList = [];

class _StartNewChatScreenState extends State<StartNewChatScreen> {
  final _userDBService = UserDatabaseService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  QuerySnapshot _searchSnapshot;
  QuerySnapshot _currentUserSnapshot;
  String _error = '';

  void _searchByEmailAddress() {
    if (_formKey.currentState.validate()) {
      _userDBService.searchUserByEmail(_textEditingController.text.trim()).then(
        (value) {
          _searchSnapshot = value;
          _recentSearchList.add(AppUser.fromJson(value.docs[0].data()));
          _error = '';
        },
      );
    }
  }

  void _createChatRoom({Map<String, dynamic> searchedUserData}) async {
    final currentUser = AppUser.fromJson(_currentUserSnapshot.docs[0].data());
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

      String chatRoomID =
          Utilities().getChatRoomID(searchedUser.email, currentUser.email);

      Map<String, Object> chatRoomMap = {
        'users': users,
        'chatRoomID': chatRoomID,
        'emails': [currentUser.email, searchedUser.email]
      };

      ChatDatabaseService().createChatRoom(chatRoomID, chatRoomMap);

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
    _userDBService
        .searchUserByEmail(FirebaseAuth.instance.currentUser.email)
        .then((value) => _currentUserSnapshot = value);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Start New Chat')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) => _searchByEmailAddress(),
                validator: (value) =>
                    value.isEmpty ? 'Please provide an email' : null,
                decoration: kTextFormInputDecoration.copyWith(
                  hintText: 'Search by Email Address...',
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text('Search Result', style: Theme.of(context).textTheme.headline6),
            _searchSnapshot == null
                ? Text('Start Searching')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchSnapshot.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = _searchSnapshot.docs[index].data();
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _createChatRoom(searchedUserData: data),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic'])),
                              title: Text(data['name']),
                              subtitle: Text(data['email']),
                              trailing: Icon(Icons.send),
                            ),
                          ),
                          Center(child: ErrorText(error: _error)),
                        ],
                      );
                    },
                  ),
            Divider(),
            SizedBox(height: size.height * 0.02),
            Text('Recently searched',
                style: Theme.of(context).textTheme.headline6),
            _recentSearchList.isEmpty
                ? Text('No Recent Search')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _recentSearchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = _recentSearchList[index];
                      return GestureDetector(
                        onTap: () =>
                            _createChatRoom(searchedUserData: data.toJson()),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(data.profilePic)),
                          title: Text(data.name),
                          subtitle: Text(data.email),
                          trailing: Icon(Icons.send),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
