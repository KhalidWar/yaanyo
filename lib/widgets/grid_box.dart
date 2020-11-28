import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GridBox extends StatelessWidget {
  const GridBox({
    Key key,
    this.storeName,
    this.storeIcon,
  }) : super(key: key);

  final String storeIcon, storeName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: SvgPicture.asset(
              storeIcon,
              width: size.width,
              height: size.height,
            ),
          ),
          Text(
            '$storeName',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
