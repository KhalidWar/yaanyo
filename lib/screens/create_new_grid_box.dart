import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaanyo/models/shopping.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/service_locator.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../constants.dart';

class CreateNewGridBox extends StatefulWidget {
  @override
  _CreateNewGridBoxState createState() => _CreateNewGridBoxState();
}

class _CreateNewGridBoxState extends State<CreateNewGridBox> {
  final _textInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ColorSwatch _mainColor = Colors.blue;
  ColorSwatch _tempMainColor;
  int _selectedIndex = 0;

  void _createNewGridBox() {
    if (_formKey.currentState.validate()) {
      Shopping shopping = Shopping(
        storeName: _textInputController.text.trim(),
        storeIcon: storeIconList[_selectedIndex],
        time: Timestamp.now(),
        gridColorInt: gridColorList.indexOf(_mainColor),
        uid: FirebaseAuth.instance.currentUser.uid,
      );
      serviceLocator<DatabaseService>().createNewGridBox(shopping: shopping);
      Navigator.pop(context);
    }
  }

  void _gridIconPicker() {
    showDialog(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return AlertDialog(
            title: Text('Grid Icon Picker'),
            content: Container(
              height: size.height * 0.5,
              width: size.width * 08,
              child: ListView.builder(
                itemCount: storeIconList.length,
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
                      child: SvgPicture.asset('${storeIconList[index]}'),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  void _gridColorPicker() {
    showDialog(
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
            selectedColor: _mainColor,
            allowShades: false,
            onMainColorChange: (color) =>
                setState(() => _tempMainColor = color),
          ),
          actions: [
            FlatButton(
                child: Text('CANCEL'), onPressed: Navigator.of(context).pop),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                    validator: (value) =>
                        value.isEmpty ? 'Field can not be empty' : null,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: kTextFormInputDecoration.copyWith(
                        hintText: 'Enter Grid Name'),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  height: size.height * 0.3,
                  width: size.width * 0.5,
                  child: GridBox(
                    storeName: _textInputController.text.trim(),
                    gridColor: _mainColor,
                    storeIcon: storeIconList[_selectedIndex],
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
                    backgroundColor: _mainColor,
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
                      storeIconList[_selectedIndex],
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Create New Grid'),
      actions: [
        IconButton(
          icon: Icon(Icons.done, color: Colors.white),
          onPressed: () => _createNewGridBox(),
        ),
      ],
    );
  }
}
