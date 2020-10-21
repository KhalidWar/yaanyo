import 'package:flutter/material.dart';
import 'package:yaanyo/screens/initial_screen.dart';
import 'package:yaanyo/services/authentication.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Authentication _authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: FlatButton(
            onPressed: () async {
              await _authentication.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return InitialScreen();
              }));
            },
            child: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ),
    );
  }
}
