import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaanyo/screens/profile/profile_screen.dart';
import 'package:yaanyo/screens/settings/settings_screen.dart';
import 'package:yaanyo/screens/shopping/shopping_task_screen.dart';
import 'package:yaanyo/state_management/providers.dart';
import 'package:yaanyo/widgets/alert_widget.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../../constants.dart';
import 'create_new_grid_box.dart';

final shoppingGridStream = StreamProvider<QuerySnapshot>(
  (ref) {
    return ref.watch(shoppingDatabaseServiceProvider).getShoppingGridStream();
  },
);

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(shoppingGridStream);

    return stream.when(
      loading: () => Center(child: CircularProgressIndicator()),
      data: (data) {
        return Scaffold(
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
        );
      },
      error: (error, stackTrace) => AlertWidget(
        label: error,
        iconData: Icons.warning_amber_rounded,
      ),
    );

    // return Scaffold(
    //   appBar: buildAppBar(context),
    //   floatingActionButton: buildFloatingActionButton(),
    //   body: StreamBuilder(
    //     // stream: shoppingServiceProvider,
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //           return AlertWidget(
    //             label: kNoInternetConnection,
    //             iconData: Icons.warning_amber_rounded,
    //           );
    //         case ConnectionState.waiting:
    //           return Center(child: CircularProgressIndicator());
    //         default:
    //           if (snapshot.data.documents.isEmpty) {
    //             return AlertWidget(lottie: 'assets/lottie/emptyBag.json');
    //           } else if (snapshot.hasError) {
    //             return AlertWidget(
    //               iconData: Icons.warning_amber_rounded,
    //               label: 'Something went wrong\n${snapshot.error}',
    //               buttonLabel: 'Sign out',
    //               buttonOnPress: () => ConfirmationDialogs().signOut(context),
    //             );
    //           } else if (snapshot.hasData) {
    //             return GridView.builder(
    //               itemCount: snapshot.data.documents.length,
    //               padding: EdgeInsets.all(8),
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 2,
    //                 childAspectRatio: 0.7,
    //                 mainAxisSpacing: 8,
    //                 crossAxisSpacing: 8,
    //               ),
    //               itemBuilder: (context, index) {
    //                 final data = snapshot.data.docs[index].data();
    //                 return OpenContainer(
    //                   closedElevation: 5,
    //                   closedColor: kGridColorList[data['gridColorInt']],
    //                   closedShape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //                   closedBuilder: (context, closedWidget) {
    //                     return GridBox(
    //                       storeName: data['storeName'],
    //                       storeIcon: data['storeIcon'],
    //                     );
    //                   },
    //                   openBuilder: (context, openWidget) {
    //                     return ShoppingTaskScreen(
    //                       storeName: data['storeName'],
    //                       gridColor: kGridColorList[data['gridColorInt']],
    //                       storeIcon: data['storeIcon'],
    //                     );
    //                   },
    //                 );
    //               },
    //             );
    //           }
    //       }
    //       return Center(child: CircularProgressIndicator());
    //     },
    //   ),
    // );
  }

  OpenContainer buildFloatingActionButton() {
    return OpenContainer(
      closedShape: CircleBorder(),
      closedElevation: 8,
      useRootNavigator: true,
      closedBuilder: (context, closedWidget) {
        return FloatingActionButton(
          // heroTag: heroTag,
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
      title: Text('Yaanyo'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));
        },
      ),
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
