import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/widgets/grid_box.dart';
import 'package:yaanyo/widgets/grid_box_detailed.dart';

class ShoppingTab extends StatefulWidget {
  static const String id = 'shopping_screen';

  @override
  _ShoppingTabState createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<ShoppingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.7,
        shrinkWrap: true,
        children: [
          GridBox(
            shopName: 'Mcdonald\'s',
            shopIcon: 'assets/images/mcdonalds.svg',
            gridColor: Colors.orange,
            checkBoxValue: false,
            checkBoxTitle: 'Test',
            onPress: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AnimatedContainer(
                    duration: Duration(seconds: 1),
                    child: GridBoxDetailed(
                      appBarTitle: 'Mcdonald\s',
                      mainColor: Colors.orange,
                      checkBoxValue: false,
                      task: 'Test',
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: 'FAB1',
      child: Icon(Icons.add),
      onPressed: () {},
    );
  }
}
