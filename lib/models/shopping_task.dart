import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingTask {
  const ShoppingTask({this.time, this.isDone, this.taskLabel});
  final bool isDone;
  final String taskLabel;
  final Timestamp time;

  factory ShoppingTask.fromJson(Map<String, dynamic> json) {
    return ShoppingTask(
      isDone: json['data'],
      taskLabel: json['data'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'isDone': isDone,
        'taskLabel': taskLabel,
        'time': time,
      };
}
