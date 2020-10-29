import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key key,
    @required String error,
  })  : _error = error,
        super(key: key);

  final String _error;

  @override
  Widget build(BuildContext context) {
    return Text(
      _error,
      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red),
    );
  }
}
