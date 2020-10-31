import 'package:flutter/material.dart';
import 'package:yaanyo/screens/settings_screen.dart';
import 'package:yaanyo/screens/tabs/profile_tab.dart';
import 'package:yaanyo/screens/tabs/shopping_tab.dart';
import 'package:yaanyo/services/shared_pref_service.dart';

import 'tabs/chat_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharedPrefService _sharedPrefService = SharedPrefService();
  int _selectedIndexStack = 0;
  String currentUserEmail;
  String currentUserName;

  void _selectedIndex(int index) {
    setState(() {
      _selectedIndexStack = index;
    });
  }

  Future _fetchUserData() async {
    currentUserEmail =
        await _sharedPrefService.getUserDetail(userDetailKey: 'userEmail');
    currentUserName =
        await _sharedPrefService.getUserDetail(userDetailKey: 'userEmail');
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: IndexedStack(
        index: _selectedIndexStack,
        children: [
          ChatTab(
              currentUserEmail: currentUserEmail,
              currentUserName: currentUserName),
          ShoppingTab(),
          ProfileTab(),
        ],
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
