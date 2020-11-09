import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';

import '../../constants.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key, this.currentUserStream}) : super(key: key);
  final Stream currentUserStream;
  static const String id = 'profile_screen';

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _error = '';

  Future _updateName() async {
    if (_formKey.currentState.validate()) {
      final userData = await serviceLocator<DatabaseService>()
          .updateUserName(_textEditingController.text.trim());
      if (userData == null) {
        setState(() {
          _error = 'Something went wrong. Could not update name';
        });
      }
      _textEditingController.clear();
      Navigator.pop(context);
      setState(() => _error = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: widget.currentUserStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          // return ConnectionNone;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasData) {
              final data = snapshot.data.docs[0].data();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${data['profilePic']}'),
                              radius: 80,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 5,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.camera_alt_outlined),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle_outlined, size: 40),
                      title: Text('${data['name']}',
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text('Tap to change your name'),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return buildAlertDialog(data, context);
                          }),
                    ),
                    ListTile(
                      leading: Icon(Icons.email_outlined, size: 40),
                      title: Text('${data['email']}',
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text(
                          'Manage email settings including email notifications'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.lock_outline, size: 40),
                      title: Text('Security & Privacy',
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle:
                          Text('Manage password, 2FA, and linked accounts'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.notifications_none_outlined, size: 40),
                      title: Text('Notifications',
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text('Manage App Notifications'),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  AlertDialog buildAlertDialog(data, BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text('Change name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _textEditingController,
              validator: (value) =>
                  value.isEmpty ? 'Name can not be empty' : null,
              autofocus: true,
              decoration: kTextFormInputDecoration.copyWith(
                  hintText: '${data['name']}'),
            ),
          ),
          Text(
            _error,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        RaisedButton(
          child: Text('Update name'),
          onPressed: () => _updateName(),
        ),
        RaisedButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
