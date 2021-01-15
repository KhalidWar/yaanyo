import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/models/shopping_task.dart';
import 'package:yaanyo/screens/shopping/create_new_grid_box.dart';
import 'package:yaanyo/state_management/create_grid_state_manager.dart';
import 'package:yaanyo/state_management/providers.dart';

final shoppingTaskManagerProvider =
    ChangeNotifierProvider((ref) => ShoppingTaskManager());

class ShoppingTaskManager extends ChangeNotifier {
  Color gridColor;
  String storeName;
  String storeIcon;

  bool _toggleTaskListValue = false;

  bool get toggleTaskListValue => _toggleTaskListValue;

  void toggleTaskList() {
    _toggleTaskListValue = !toggleTaskListValue;
    notifyListeners();
  }

  Future<void> addTask(BuildContext context, GlobalKey<FormState> formKey,
      String taskLabel, String storeName) async {
    if (formKey.currentState.validate()) {
      final shoppingTask = ShoppingTask(
          taskLabel: taskLabel, isDone: false, time: Timestamp.now());
      context
          .read(shoppingServiceProvider)
          .addShoppingTask(storeName, shoppingTask);
    }
  }

  Future<void> toggleShoppingTask(BuildContext context, bool toggle,
      String taskLabel, String storeName) async {
    final shoppingTask = ShoppingTask(
      isDone: toggle,
      taskLabel: taskLabel,
      time: Timestamp.now(),
    );

    await context
        .read(shoppingServiceProvider)
        .toggleShoppingTask(shoppingTask, storeName);
  }

  void editGrid(BuildContext context, Color gridColor, String storeName,
      String storeIcon) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);
          return SlideTransition(
            position: Tween(
              begin: Offset(1.0, 0.0),
              end: Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondAnimation) {
          final createGridProvider =
              context.read(createGridStateManagerProvider);

          createGridProvider.gridColor = gridColor;
          createGridProvider.storeName = storeName;
          createGridProvider.storeIcon = storeIcon;
          return CreateNewGridBox();
        },
      ),
    );
  }

  void deleteGrid(
      BuildContext context, String storeName, List<String> gridTasksList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
              'Are you sure you want to delete $storeName grid and all of its tasks?'),
          actions: [
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                context
                    .read(shoppingServiceProvider)
                    .deleteShoppingGrid(storeName, gridTasksList);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
