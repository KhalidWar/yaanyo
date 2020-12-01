import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/utilities/confirmation_dialog.dart';

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
                onPressed: () => ConfirmationDialogs().signOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
