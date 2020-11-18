import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingGrid {
  const ShoppingGrid({
    this.storeName,
    this.storeIcon,
    this.gridColorInt,
    this.time,
  });

  final String storeName, storeIcon;
  final int gridColorInt;
  final Timestamp time;

  factory ShoppingGrid.fromJson(Map<String, dynamic> json) {
    return ShoppingGrid(
      storeName: json['storeName'],
      storeIcon: json['storeIcon'],
      gridColorInt: json['gridColorInt'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'storeName': storeName,
        'storeIcon': storeIcon,
        'gridColorInt': gridColorInt,
        'time': time,
      };
}
