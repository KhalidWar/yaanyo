import 'package:flutter/material.dart';

class StartNewChat extends StatelessWidget {
  const StartNewChat({
    Key key,
    @required this.onPress,
  }) : super(key: key);

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 25),
      child: GestureDetector(
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add),
            SizedBox(width: size.width * 0.01),
            Text(
              'Start New Chat',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
