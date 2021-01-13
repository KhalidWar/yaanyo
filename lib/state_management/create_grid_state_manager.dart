import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yaanyo/models/shopping_grid.dart';
import 'package:yaanyo/state_management/providers.dart';

import '../constants.dart';

final createGridStateManagerProvider =
    ChangeNotifierProvider((ref) => CreateGridStateManager());

class CreateGridStateManager extends ChangeNotifier {
  Color gridColor;
  String storeName;
  String storeIcon;

  ColorSwatch mainColor;
  int selectedIndex;

  void createGrid(
      BuildContext context, GlobalKey<FormState> formKey, String gridName) {
    if (formKey.currentState.validate()) {
      final shoppingGrid = ShoppingGrid(
        storeName: gridName,
        storeIcon: kStoreIconList[selectedIndex ?? 0],
        time: Timestamp.now(),
        gridColorInt: kGridColorList.indexOf(mainColor ?? Colors.red),
      );

      context.read(shoppingServiceProvider).createNewShoppingGrid(shoppingGrid);
      Navigator.pop(context);
    }
  }

  void updateGrid(BuildContext context, String newStoreName) {
    final shoppingGrid = ShoppingGrid(
      storeName: newStoreName.isEmpty ? storeName : newStoreName,
      storeIcon:
          selectedIndex == null ? storeIcon : kStoreIconList[selectedIndex],
      gridColorInt: mainColor == null
          ? kGridColorList.indexOf(gridColor)
          : kGridColorList.indexOf(mainColor),
      time: Timestamp.now(),
    );
    context
        .read(shoppingServiceProvider)
        .updateShoppingGrid(storeName, shoppingGrid);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void gridColorPicker(BuildContext context) {
    showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Grid Color picker"),
          content: MaterialColorPicker(
            shrinkWrap: true,
            colors: [
              Colors.red,
              Colors.orange,
              Colors.lightGreen,
              Colors.blue,
            ],
            selectedColor: mainColor ?? gridColor,
            allowShades: false,
            onMainColorChange: (color) {
              mainColor = color;
              gridColor = color;
              Navigator.pop(context);
              notifyListeners();
            },
          ),
        );
      },
    );
  }

  void gridIconPicker(BuildContext context) {
    showModal(
      context: context,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        return AlertDialog(
          title: Text('Grid Icon Picker'),
          content: Container(
            height: size.height * 0.5,
            width: size.width * 08,
            child: ListView.builder(
              itemCount: kStoreIconList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    selectedIndex = index;
                    storeIcon = kStoreIconList[index];
                    Navigator.pop(context);
                    notifyListeners();
                  },
                  title: Container(
                    height: size.height * 0.08,
                    child: SvgPicture.asset('${kStoreIconList[index]}'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
