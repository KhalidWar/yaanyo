import 'package:cloud_firestore/cloud_firestore.dart';

class Shopping {
  const Shopping({
    this.storeName,
    this.storeIcon,
    this.gridColorInt,
    this.time,
    this.uid,
  });

  final String storeName, storeIcon, uid;
  final int gridColorInt;
  final Timestamp time;

  factory Shopping.fromJson(Map<String, dynamic> json) {
    return Shopping(
      storeName: json['storeName'],
      storeIcon: json['storeIcon'],
      gridColorInt: json['gridColorInt'],
      time: json['time'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'storeName': storeName,
        'storeIcon': storeIcon,
        'gridColorInt': gridColorInt,
        'time': time,
        'uid': uid,
      };
}
