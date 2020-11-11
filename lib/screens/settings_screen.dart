import 'package:flutter/material.dart';
import 'package:yaanyo/screens/initial_screen.dart';
import 'package:yaanyo/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Center(
          child: FlatButton(
            onPressed: () async {
              await _authService.signOut();
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
