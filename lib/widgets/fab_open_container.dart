import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FABOpenContainer extends StatelessWidget {
  const FABOpenContainer({
    Key key,
    this.child,
    this.iconData,
    this.heroTag,
  }) : super(key: key);

  final Widget child;
  final IconData iconData;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: CircleBorder(),
      closedElevation: 8,
      useRootNavigator: true,
      closedBuilder: (context, closedWidget) {
        return FloatingActionButton(
          heroTag: heroTag,
          child: Icon(iconData),
          onPressed: closedWidget,
        );
      },
      openBuilder: (context, openWidget) {
        return child;
      },
    );
  }
}
