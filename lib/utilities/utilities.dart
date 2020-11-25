import 'package:cloud_firestore/cloud_firestore.dart';

class Utilities {
  String getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  String getMinutesInDoubleDigits(Timestamp time) {
    int minute = time.toDate().minute;
    return '$minute'.length == 1 ? '0$minute' : '$minute';
  }
}
