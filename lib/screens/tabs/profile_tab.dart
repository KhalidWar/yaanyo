import 'package:flutter/material.dart';
import 'package:yaanyo/services/database_service.dart';

class ProfileTab extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [],
      ),
    );
  }
}
