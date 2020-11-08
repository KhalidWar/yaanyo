import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaanyo/models/app_user.dart';
import 'package:yaanyo/screens/initial_screen.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/services/service_locator.dart';

void main() async {
  initServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: serviceLocator<AuthService>().user,
      child: MaterialApp(
        title: 'Yaanyo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: InitialScreen(),
      ),
    );
  }
}
