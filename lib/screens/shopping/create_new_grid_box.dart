import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaanyo/models/shopping_grid.dart';
import 'package:yaanyo/state_management/providers.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../../constants.dart';

class CreateNewGridBox extends StatefulWidget {
  const CreateNewGridBox({this.storeName, this.gridColor, this.storeIcon});

  final Color gridColor;
  final String storeName;
  final String storeIcon;

  @override
  _CreateNewGridBoxState createState() => _CreateNewGridBoxState();
}

class _CreateNewGridBoxState extends State<CreateNewGridBox> {
  final _textInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ColorSwatch _mainColor;
  int _selectedIndex;

  void _createNewGridBox() {
    if (_formKey.currentState.validate()) {
      ShoppingGrid shoppingGrid = ShoppingGrid(
        storeName: _textInputController.text.trim(),
        storeIcon: kStoreIconList[_selectedIndex ?? 0],
        time: Timestamp.now(),
        gridColorInt: kGridColorList.indexOf(_mainColor ?? Colors.red),
      );
      context
          .read(shoppingServiceProvider)
          .createNewShoppingGrid(shoppingGrid: shoppingGrid);
      Navigator.pop(context);
    }
  }

  void _updateGridBox() {
    ShoppingGrid shoppingGrid = ShoppingGrid(
      storeName: _textInputController.text.trim().isEmpty
          ? widget.storeName
          : _textInputController.text.trim(),
      storeIcon: _selectedIndex == null
          ? widget.storeIcon
          : kStoreIconList[_selectedIndex],
      gridColorInt: _mainColor == null
          ? kGridColorList.indexOf(widget.gridColor)
          : kGridColorList.indexOf(_mainColor),
    );
    context.read(shoppingServiceProvider).updateShoppingGrid(
          storeName: widget.storeName,
          shoppingGrid: shoppingGrid,
        );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _gridColorPicker() {
    showModal(
      context: context,
      builder: (_) {
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
            selectedColor: _mainColor ?? widget.gridColor,
            allowShades: false,
            onMainColorChange: (color) {
              setState(() {
                _mainColor = color;
                print(_mainColor);
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _gridIconPicker() {
    showModal(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
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
                      setState(() {
                        _selectedIndex = index;
                        Navigator.pop(context);
                      });
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
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Scaffold(
          appBar: buildAppBar(),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _textInputController,
                      validator: (input) =>
                          FormValidator().createNewGridBox(input),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: kTextFormInputDecoration.copyWith(
                        hintText: widget.storeName == null
                            ? 'Enter Grid Name'
                            : widget.storeName,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    height: size.height * 0.32,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: widget.gridColor == null
                          ? _mainColor ?? kGridColorList[0]
                          : widget.gridColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridBox(
                      storeName: widget.storeName == null
                          ? _textInputController.text.trim()
                          : widget.storeName,
                      storeIcon: widget.storeIcon == null
                          ? kStoreIconList[_selectedIndex ?? 0]
                          : widget.storeIcon,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ListTile(
                    onTap: _gridColorPicker,
                    leading: Text(
                      'Grid Color',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: widget.gridColor == null
                          ? _mainColor ?? kGridColorList[0]
                          : widget.gridColor,
                      radius: 25,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ListTile(
                    onTap: _gridIconPicker,
                    leading: Text(
                      'Grid Icon',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      child: SvgPicture.asset(
                        widget.storeIcon == null
                            ? kStoreIconList[_selectedIndex ?? 0]
                            : widget.storeIcon,
                        width: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Create New Grid'),
      brightness: Brightness.dark,
      actions: [
        IconButton(
          icon: Icon(Icons.done, color: Colors.white),
          onPressed: () =>
              widget.storeName == null ? _createNewGridBox() : _updateGridBox(),
        ),
      ],
    );
  }
}
