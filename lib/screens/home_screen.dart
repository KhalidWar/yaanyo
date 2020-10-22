import 'package:flutter/material.dart';
import 'package:yaanyo/screens/profile_tab.dart';
import 'package:yaanyo/screens/settings_screen.dart';
import 'package:yaanyo/screens/shopping_tab.dart';

import 'chat_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndexStack = 0;

  void _selectedIndex(int index) {
    setState(() {
      _selectedIndexStack = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: IndexedStack(
            index: _selectedIndexStack,
            children: [
              ChatScreen(),
              ShoppingScreen(),
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndexStack,
          onTap: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Chat',
              icon: Icon(Icons.chat),
            ),
            BottomNavigationBarItem(
              label: 'Shopping',
              icon: Icon(Icons.shopping_cart_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Yaanyo'),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SettingsScreen();
            }));
          },
        ),
      ],
    );
  }
}
