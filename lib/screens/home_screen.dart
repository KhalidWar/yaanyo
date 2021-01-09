import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/screens/settings/settings_screen.dart';
import 'package:yaanyo/screens/shopping/shopping_task_screen.dart';
import 'package:yaanyo/state_management/providers.dart';
import 'package:yaanyo/widgets/alert_widget.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../constants.dart';
import 'shopping/create_new_grid_box.dart';

final shoppingGridStream = StreamProvider<QuerySnapshot>((ref) {
  return ref.watch(shoppingDatabaseServiceProvider).getShoppingGridStream();
});

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(shoppingGridStream);

    return stream.when(
      loading: () => Center(child: CircularProgressIndicator()),
      data: (data) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Scaffold(
            appBar: buildAppBar(context),
            floatingActionButton: buildFloatingActionButton(),
            body: GridView.builder(
              itemCount: data.docs.length,
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final gridData = data.docs[index].data();

                if (data.docs.isEmpty) {
                  return AlertWidget(lottie: 'assets/lottie/emptyBag.json');
                }

                return OpenContainer(
                  closedElevation: 5,
                  closedColor: kGridColorList[gridData['gridColorInt']],
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  closedBuilder: (context, closedWidget) {
                    return GridBox(
                      storeName: gridData['storeName'],
                      storeIcon: gridData['storeIcon'],
                    );
                  },
                  openBuilder: (context, openWidget) {
                    return ShoppingTaskScreen(
                      storeName: gridData['storeName'],
                      gridColor: kGridColorList[gridData['gridColorInt']],
                      storeIcon: gridData['storeIcon'],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
      error: (error, stackTrace) => AlertWidget(
        label: error,
        iconData: Icons.warning_amber_rounded,
      ),
    );
  }

  OpenContainer buildFloatingActionButton() {
    return OpenContainer(
      closedShape: CircleBorder(),
      closedElevation: 8,
      useRootNavigator: true,
      closedBuilder: (context, closedWidget) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: closedWidget,
        );
      },
      openBuilder: (context, openWidget) {
        return CreateNewGridBox();
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,
      title: Text('Yaanyo'),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ),
      ],
    );
  }
}
