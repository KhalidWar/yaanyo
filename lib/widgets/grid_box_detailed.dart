import 'package:flutter/material.dart';

class GridBoxDetailed extends StatelessWidget {
  const GridBoxDetailed({
    Key key,
    this.mainColor,
    this.appBarTitle,
    this.task,
    this.checkBoxValue,
  }) : super(key: key);

  final Color mainColor;
  final String appBarTitle, task;
  final bool checkBoxValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Icon(Icons.reorder_rounded),
                Checkbox(
                  value: checkBoxValue,
                  onChanged: (toggle) {},
                ),
                Text(
                  task,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
