import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/screens/shopping/shopping_task_screen.dart';
import 'package:yaanyo/services/database/shopping_database_service.dart';
import 'package:yaanyo/utilities/confirmation_dialog.dart';
import 'package:yaanyo/widgets/alert_widget.dart';
import 'package:yaanyo/widgets/fab_open_container.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../../constants.dart';
import 'create_new_grid_box.dart';

class ShoppingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final shoppingGridStream =
        watch(shoppingDatabaseServiceProvider).getShoppingGridStream();
    return Scaffold(
      floatingActionButton: FABOpenContainer(
          heroTag: 'shoppingTab',
          iconData: Icons.add,
          child: CreateNewGridBox()),
      body: StreamBuilder(
        stream: shoppingGridStream,
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
              if (snapshot.data.documents.isEmpty) {
                return AlertWidget(
                  label: kGridList,
                  iconData: Icons.list_alt,
                );
              } else if (snapshot.hasError) {
                return AlertWidget(
                  iconData: Icons.warning_amber_rounded,
                  label: 'Something went wrong\n${snapshot.error}',
                  buttonLabel: 'Sign out',
                  buttonOnPress: () => ConfirmationDialogs().signOut(context),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final data = snapshot.data.docs[index].data();
                    return OpenContainer(
                      closedElevation: 5,
                      closedColor: kGridColorList[data['gridColorInt']],
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      closedBuilder: (context, closedWidget) {
                        return GridBox(
                          storeName: data['storeName'],
                          storeIcon: data['storeIcon'],
                        );
                      },
                      openBuilder: (context, openWidget) {
                        return ShoppingTaskScreen(
                          storeName: data['storeName'],
                          gridColor: kGridColorList[data['gridColorInt']],
                          storeIcon: data['storeIcon'],
                        );
                      },
                    );
                  },
                );
              }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
