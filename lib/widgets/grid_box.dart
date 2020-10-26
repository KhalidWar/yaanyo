import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridBox extends StatelessWidget {
  const GridBox({
    Key key,
    this.onPress,
    this.gridColor,
    this.shopName,
    this.checkBoxValue,
    this.checkBoxTitle,
    this.shopIcon,
  }) : super(key: key);

  final Function onPress;
  final Color gridColor;
  final String shopIcon, shopName, checkBoxTitle;
  final bool checkBoxValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: gridColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Expanded(
              child: SvgPicture.asset(
                shopIcon,
                width: size.width,
                height: size.height,
              ),
            ),
            Text(
              shopName,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
