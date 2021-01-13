import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/services/user_service.dart';
import 'package:yaanyo/state_management/settings_state_manager.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/alert_widget.dart';

import '../../constants.dart';

final userStream = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return ref.read(userServiceProvider).getCurrentUserStream();
});

class SettingsScreen extends ConsumerWidget {
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final stream = watch(userStream);

    final settingsManager = watch(settingsManagerProvider);
    final updateName = settingsManager.updateName;
    final signOut = settingsManager.signOut;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.red,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Settings'), brightness: Brightness.dark),
        body: stream.when(
          loading: () => Center(child: CircularProgressIndicator()),
          data: (data) {
            final userData = data.docs[0].data();

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle_outlined, size: 40),
                  title: Text('${userData['name']}',
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text('Tap to change your name'),
                  onTap: () =>
                      buildUpdateNameDialog(context, userData, updateName),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined, size: 40),
                  title: Text('${userData['email']}',
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text(
                      'Manage email settings including email notifications'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline, size: 40),
                  title: Text('Security & Privacy',
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text('Manage password, 2FA, and linked accounts'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.nights_stay_outlined, size: 40),
                  title: Text('Dark Theme',
                      style: Theme.of(context).textTheme.bodyText1),
                  subtitle: Text('Manage App theme'),
                  // onTap: () {},
                  trailing: Switch(
                    value: false,
                    onChanged: (toggle) {},
                  ),
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  height: size.height * 0.06,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Log Out',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    onPressed: () => signOut(context),
                  ),
                ),
              ],
            );
          },
          error: ((error, stackTrace) {
            return AlertWidget(
              label: error,
              iconData: Icons.warning_amber_rounded,
            );
          }),
        ),
      ),
    );
  }

  Future buildUpdateNameDialog(BuildContext context,
      Map<String, dynamic> userData, Function updateName) {
    return showModal(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(10),
        title: Text('Change name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _textEditingController,
                validator: (input) => FormValidator().updateNameField(input),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: kTextFormInputDecoration.copyWith(
                    hintText: '${userData['name']}'),
              ),
            ),
          ],
        ),
        actions: [
          RaisedButton(
              child: Text('Update name'),
              onPressed: () {
                updateName(
                  context,
                  _formKey,
                  _textEditingController.text.trim(),
                );
                _textEditingController.clear();
              }),
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
