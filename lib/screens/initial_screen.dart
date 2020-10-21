import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/screens/home_screen.dart';
import 'package:yaanyo/screens/sign_in_screen.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return user == null ? SignInScreen() : HomeScreen();
  }
}
