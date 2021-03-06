import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/state_management/providers.dart';

import '../home_screen.dart';

final userStream =
    StreamProvider((ref) => ref.watch(authServiceProvider).userStream());

class InitialScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(userStream);

    return stream.when(
        loading: () => Center(child: CircularProgressIndicator()),
        data: (data) {
          if (data == null) {
            return SignInScreen();
          } else {
            return HomeScreen();
          }
        },
        error: (error, stackTrace) {
          return;
        });
  }
}
