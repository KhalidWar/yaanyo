import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:yaanyo/models/shopping_task.dart';
import 'package:yaanyo/services/database/shopping_database_service.dart';
import 'package:yaanyo/utilities/confirmation_dialog.dart';
import 'package:yaanyo/widgets/alert_widget.dart';

import '../../constants.dart';

class ShoppingTaskScreen extends StatefulWidget {
  const ShoppingTaskScreen({
    Key key,
    this.gridColor,
    this.storeName,
  }) : super(key: key);

  final Color gridColor;
  final String storeName;

  @override
  _ShoppingTaskScreenState createState() => _ShoppingTaskScreenState();
}

class _ShoppingTaskScreenState extends State<ShoppingTaskScreen> {
  final _taskInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _shoppingDBService = ShoppingDatabaseService();
  final _gridTasksList = <String>[];

  Stream<QuerySnapshot> shoppingTaskStream;

  Future _addTask() async {
    if (_formKey.currentState.validate()) {
      final shoppingTask = ShoppingTask(
        taskLabel: _taskInputController.text.trim(),
        isDone: false,
        time: Timestamp.now(),
      );

      _shoppingDBService.addShoppingTask(
        storeName: widget.storeName,
        shoppingTask: shoppingTask,
      );
      _taskInputController.clear();
    }
  }

  void _toggleShoppingTask(bool toggle, String taskLabel) {
    final ShoppingTask shoppingTask = ShoppingTask(
        isDone: toggle, taskLabel: taskLabel, time: Timestamp.now());

    _shoppingDBService.toggleShoppingTask(
      storeName: widget.storeName,
      shoppingTask: shoppingTask,
    );
  }

  @override
  void initState() {
    super.initState();
    shoppingTaskStream =
        _shoppingDBService.getShoppingTaskStream(widget.storeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: widget.gridColor,
        appBar: buildAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: shoppingTaskStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return AlertWidget(
                        label: kNoInternetConnection,
                        iconData: Icons.warning_amber_rounded,
                      );
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.data.docs.isEmpty) {
                        return AlertWidget(
                          iconData: Icons.receipt_long,
                          label: kTaskList,
                        );
                      } else if (snapshot.hasError) {
                        return AlertWidget(
                          iconData: Icons.warning_amber_rounded,
                          label: 'Something went wrong\n${snapshot.error}',
                          buttonLabel: 'Sign out',
                          buttonOnPress: () =>
                              ConfirmationDialogs().signOut(context),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          padding: EdgeInsets.only(left: 18),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data.docs[index].data();
                            _gridTasksList.add(data['taskLabel']);

                            return Row(
                              children: <Widget>[
                                Icon(
                                  Icons.reorder_rounded,
                                  color: Colors.black45,
                                ),
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: data['isDone'],
                                  onChanged: (toggle) => _toggleShoppingTask(
                                    toggle,
                                    data['taskLabel'],
                                  ),
                                ),
                                Text(
                                  data['taskLabel'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        decoration: data['isDone']
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.gridColor,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _taskInputController,
                        validator: (value) =>
                            value.isEmpty ? 'Field can not be empty' : null,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _addTask(),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add task here...',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addTask(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(widget.storeName),
      backgroundColor: widget.gridColor,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return {'Delete ${widget.storeName} Grid'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (value) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Delete this grid and all of its tasks?'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        _shoppingDBService.deleteShoppingGrid(
                            storeName: widget.storeName,
                            gridTasksList: _gridTasksList);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
