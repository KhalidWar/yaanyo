import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/services/database_service.dart';

class StartNewChatScreen extends StatefulWidget {
  @override
  _StartNewChatScreenState createState() => _StartNewChatScreenState();
}

class _StartNewChatScreenState extends State<StartNewChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  DatabaseService _databaseService = DatabaseService();

  QuerySnapshot searchSnapshot;
  String _error = '';

  void search() {
    if (_textEditingController.text.isEmpty || _textEditingController == null) {
      setState(() {
        _error = 'Search field cannot be empty';
      });
    } else {
      _databaseService.searchUserByEmail(_textEditingController.text).then(
        (value) {
          setState(() {
            searchSnapshot = value;
          });
        },
      );
    }
  }

  Widget searchResultWidget() {
    return searchSnapshot == null
        ? Text(
            _error,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.red),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  child: ListTile(
                    title: Text(searchSnapshot.docs[index].data()['name']),
                    subtitle: Text(searchSnapshot.docs[index].data()['email']),
                    trailing: Icon(Icons.send),
                  ),
                ),
              );
            },
          );
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
                      onSubmitted: (value) => search(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by email address',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      search();
                    },
                  ),
                ],
              ),
            ),
            searchResultWidget(),
          ],
        ),
      ),
    );
  }
}
