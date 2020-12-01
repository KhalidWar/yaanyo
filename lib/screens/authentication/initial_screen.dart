import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/widgets/alert_widget.dart';

import '../../constants.dart';
import '../home_screen.dart';

class InitialScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userStream = watch(authServiceProvider).userStream();

    return StreamBuilder<User>(
      stream: userStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return AlertWidget(
              label: kNoInternetConnection,
              iconData: Icons.warning_amber_rounded,
            );
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.data == null) {
              return SignInScreen();
            } else {
              return HomeScreen();
            }
        }
      },
    );
  }
}
