import 'package:flutter/material.dart';

class ErrorMessageAlert extends StatelessWidget {
  const ErrorMessageAlert({
    Key key,
    @required String errorMessage,
  })  : errorMessage = errorMessage,
        super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (errorMessage == null) {
      return Container();
    } else {
      return Container(
        width: double.infinity,
        color: Colors.amberAccent,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.error_outline),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: Text(
                errorMessage,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
    }
  }
}
