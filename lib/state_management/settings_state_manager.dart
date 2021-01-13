import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/services/user_database_service.dart';
import 'package:yaanyo/state_management/providers.dart';

final settingsManagerProvider =
    ChangeNotifierProvider((ref) => SettingsStateManager());

class SettingsStateManager extends ChangeNotifier {
  void updateName(
      BuildContext context, GlobalKey<FormState> formKey, String newName) {
    if (formKey.currentState.validate()) {
      context.read(userServiceProvider).updateUserName(newName);
      Navigator.pop(context);
    }
  }

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
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
