import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/authentication/sign_in_screen.dart';
import 'package:yaanyo/screens/shopping_task_screen.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';
import 'package:yaanyo/widgets/grid_box.dart';
import 'package:yaanyo/widgets/warning_widget.dart';

import '../../constants.dart';
import '../create_new_grid_box.dart';

class ShoppingTab extends StatefulWidget {
  static const String id = 'shopping_screen';

  @override
  _ShoppingTabState createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<ShoppingTab> {
  Stream<QuerySnapshot> shoppingStream;

  @override
  void initState() {
    super.initState();
    shoppingStream = serviceLocator<DatabaseService>().getShoppingGridStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: StreamBuilder(
        stream: shoppingStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return WarningWidget(
                  iconData: Icons.warning_amber_rounded,
                  label:
                      'No Internet Connection \n Please make sure you\'re online',
                  buttonLabel: 'Try again',
                  buttonOnPress: () {});
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.data.documents.isEmpty) {
                return WarningWidget(
                    iconData: Icons.hourglass_empty,
                    label: 'Grid list is empty',
                    buttonOnPress: () {});
              } else if (snapshot.hasError) {
                return WarningWidget(
                  iconData: Icons.warning_amber_rounded,
                  label: 'Something went wrong. \n Please sign in again!',
                  buttonLabel: 'Sign in again',
                  buttonOnPress: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen())),
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
                    return GridBox(
                      storeName: data['storeName'],
                      storeIcon: data['storeIcon'],
                      gridColor: gridColorList[data['gridColorInt']],
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ShoppingTaskScreen(
                                storeName: data['storeName'],
                                gridColor: gridColorList[data['gridColorInt']],
                              );
                            },
                          ),
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

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: 'FAB1',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CreateNewGridBox();
        }));
      },
    );
  }
}
