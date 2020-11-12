import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key key,
    this.message,
    this.sender,
    this.time,
  }) : super(key: key);

  final String message;
  final Timestamp time;
  final bool sender;

  String minutes(Timestamp time) {
    int minute = time.toDate().minute;
    return '$minute'.length == 1 ? '0$minute' : '$minute';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: sender ? Colors.blue[300] : Colors.grey[300],
          borderRadius: sender
              ? BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))
              : BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment:
              sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontSize: size.height * 0.02),
            ),
            SizedBox(height: 5),
            Text(
              '${time.toDate().hour}:${minutes(time)}',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
