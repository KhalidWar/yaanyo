import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key key,
    this.label,
    this.iconData,
    this.buttonLabel,
    this.buttonOnPress,
    this.iconColor,
    this.scaffoldColor,
    this.lottie,
    this.lottieHeight,
  }) : super(key: key);

  final String label, buttonLabel, lottie;
  final IconData iconData;
  final Function buttonOnPress;
  final Color iconColor, scaffoldColor;
  final double lottieHeight;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          scaffoldColor == null ? Colors.transparent : scaffoldColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  iconData == null
                      ? Container()
                      : Icon(
                          iconData,
                          color: iconColor,
                          size: size.height * 0.1,
                        ),
                  lottie == null
                      ? Container()
                      : Lottie.asset(
                          lottie,
                          height: lottieHeight,
                          fit: BoxFit.fitHeight,
                        ),
                  label == null
                      ? Container()
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                ],
              ),
            ),
            buttonLabel == null
                ? Container()
                : RaisedButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.2,
                      vertical: 20,
                    ),
                    child: Text(
                      buttonLabel,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onPressed: buttonLabel == null ? () {} : buttonOnPress,
                  ),
          ],
        ),
      ),
    );
  }
}
