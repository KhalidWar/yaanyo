import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/state_management/providers.dart';
import 'package:yaanyo/state_management/shopping_task_state_manager.dart';
import 'package:yaanyo/widgets/alert_widget.dart';

final shoppingTaskStream = StreamProvider.autoDispose<QuerySnapshot>(
  (ref) {
    final storeName = ref.read(shoppingTaskManagerProvider).storeName;
    return ref.read(shoppingServiceProvider).getShoppingTaskStream(storeName);
  },
);

class ShoppingTaskScreen extends ConsumerWidget {
  final _taskInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _gridTasksList = <String>[];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(shoppingTaskStream);

    final shoppingTaskProvider = watch(shoppingTaskManagerProvider);
    final gridColor = shoppingTaskProvider.gridColor;
    final storeName = shoppingTaskProvider.storeName;
    final storeIcon = shoppingTaskProvider.storeIcon;
    final toggleCheckedTaskList = shoppingTaskProvider.toggleTaskListValue;
    final toggleTaskList = shoppingTaskProvider.toggleTaskList;
    final addTask = shoppingTaskProvider.addTask;
    final toggleShoppingTask = shoppingTaskProvider.toggleShoppingTask;
    final editGrid = shoppingTaskProvider.editGrid;
    final deleteGrid = shoppingTaskProvider.deleteGrid;

    List<String> choicesList = [
      'Edit Grid',
      'Delete Grid',
    ];

    void choicesOnSelected(String choice) {
      if (choice == 'Edit Grid') {
        editGrid(context, gridColor, storeName, storeIcon);
      } else {
        deleteGrid(context, storeName, _gridTasksList);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: gridColor),
        child: Scaffold(
          backgroundColor: gridColor,
          appBar: buildAppBar(
            storeName,
            gridColor,
            toggleCheckedTaskList,
            toggleTaskList,
            choicesList,
            choicesOnSelected,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: stream.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (data) {
                    final docs = data.docs;

                    if (docs.isEmpty) {
                      return buildEmptyTasksWidget(context);
                    }

                    List<Map<String, dynamic>> checkedTaskList = [];
                    List<Map<String, dynamic>> uncheckedTaskList = [];

                    for (var i = 0; i < docs.length; i++) {
                      _gridTasksList.add(docs[i]['taskLabel']);
                      if (docs[i].data()['isDone'] == true) {
                        checkedTaskList.add(docs[i].data());
                      } else {
                        uncheckedTaskList.add(docs[i].data());
                      }
                    }

                    final toggledList = toggleCheckedTaskList
                        ? checkedTaskList
                        : uncheckedTaskList;

                    return toggledList.isEmpty
                        ? buildEmptyTasksWidget(context)
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            shrinkWrap: true,
                            itemCount: toggledList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: <Widget>[
                                  Checkbox(
                                    visualDensity: VisualDensity.compact,
                                    activeColor: Colors.black54,
                                    value: toggledList[index]['isDone'],
                                    onChanged: (toggle) {
                                      toggleShoppingTask(
                                        context,
                                        toggle,
                                        toggledList[index]['taskLabel'],
                                        storeName,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      toggledList[index]['taskLabel'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            decoration: toggledList[index]
                                                    ['isDone']
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                  },
                  error: ((error, stackTrace) {
                    return AlertWidget(
                      iconData: Icons.warning_amber_rounded,
                      label: 'Something went wrong\n$error',
                      buttonLabel: 'Sign out',
                    );
                  }),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: gridColor,
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
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (value) {
                            addTask(context, _formKey,
                                _taskInputController.text.trim(), storeName);
                            _taskInputController.clear();
                          },
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
                      onPressed: () {
                        addTask(context, _formKey,
                            _taskInputController.text.trim(), storeName);
                        _taskInputController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertWidget buildEmptyTasksWidget(BuildContext context) {
    return AlertWidget(
      lottie: 'assets/lottie/check.json',
      label: 'All done.',
      lottieHeight: MediaQuery.of(context).size.height * 0.3,
    );
  }

  AppBar buildAppBar(
      storeName,
      gridColor,
      toggleCheckedTaskList,
      Function toggleTaskList,
      List<String> choicesList,
      Function choicesOnSelected) {
    return AppBar(
      title: Text(storeName),
      backgroundColor: gridColor,
      brightness: Brightness.dark,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            toggleCheckedTaskList
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank,
          ),
          onPressed: () => toggleTaskList(),
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return choicesList.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: choicesOnSelected,
        ),
      ],
    );
  }
}
