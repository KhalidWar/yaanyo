import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Spacer(),
            Container(
              width: double.infinity,
              height: size.height * 0.05,
              child: RaisedButton(
                color: Colors.red,
                child: Text('Log Out',
                    style: Theme.of(context).textTheme.headline6),
                onPressed: () => buildShowModal(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future buildShowModal(context) {
    return showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Are you sure you want to sign out?'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                context.read(authServiceProvider).signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
