import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/state_management/providers.dart';

class ConfirmationDialogs {
  void signOut(context) {
    showModal(
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
                }),
            FlatButton(
                child: Text('No'), onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }
}
