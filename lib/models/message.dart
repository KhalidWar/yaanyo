import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  const Message({
    @required this.message,
    @required this.time,
    @required this.sender,
  });

  final String sender, message;
  final Timestamp time;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      time: json['time'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'time': time,
        'sender': sender,
      };
}
