import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaanyo/state_management/create_grid_state_manager.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/grid_box.dart';

import '../../constants.dart';

class CreateNewGridBox extends ConsumerWidget {
  final _textInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final createGridProvider = watch(createGridStateManagerProvider);
    final gridColor = createGridProvider.gridColor;
    final storeName = createGridProvider.storeName;
    final storeIcon = createGridProvider.storeIcon;

    final mainColor = createGridProvider.mainColor;
    final selectedIndex = createGridProvider.selectedIndex;
    final gridColorPicker = createGridProvider.gridColorPicker;
    final gridIconPicker = createGridProvider.gridIconPicker;

    final createGridBox = createGridProvider.createGrid;
    final updateGridBox = createGridProvider.updateGrid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                storeName == null ? 'Create New Grid' : 'Update $storeName'),
            brightness: Brightness.dark,
            actions: [
              IconButton(
                icon: Icon(Icons.done, color: Colors.white),
                onPressed: () {
                  storeName == null
                      ? createGridBox(
                          context, _formKey, _textInputController.text.trim())
                      : updateGridBox(
                          context, _textInputController.text.trim());
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  storeName == null
                      ? Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _textInputController,
                            validator: (input) =>
                                FormValidator().createNewGridBox(input),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: kTextFormInputDecoration.copyWith(
                              hintText: storeName == null
                                  ? 'Enter Grid Name'
                                  : storeName,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    height: size.height * 0.32,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: gridColor == null
                          ? mainColor ?? kGridColorList[0]
                          : gridColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridBox(
                      storeName: storeName == null
                          ? _textInputController.text.trim()
                          : storeName,
                      storeIcon: storeIcon == null
                          ? kStoreIconList[selectedIndex ?? 0]
                          : storeIcon,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ListTile(
                    onTap: () => gridColorPicker(context),
                    leading: Text(
                      'Grid Color',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: gridColor == null
                          ? mainColor ?? kGridColorList[0]
                          : gridColor,
                      radius: 25,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ListTile(
                    onTap: () => gridIconPicker(context),
                    leading: Text(
                      'Grid Icon',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25,
                      child: SvgPicture.asset(
                        storeIcon == null
                            ? kStoreIconList[selectedIndex ?? 0]
                            : storeIcon,
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
}
