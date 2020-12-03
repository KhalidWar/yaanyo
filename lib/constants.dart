import 'package:flutter/material.dart';

const kDefaultProfilePic =
    'https://images.unsplash.com/photo-1544502062-f82887f03d1c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1427&q=80';

const kNoInternetConnection = 'No Internet Connection';
const kSomethingWentWrong = 'Something went wrong';
const kLottieErrorCone = 'assets/lottie/errorCone.json';

const kTextFormInputDecoration = InputDecoration(
  border: OutlineInputBorder(),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
);

const List<Color> kGridColorList = [
  Colors.red,
  Colors.orange,
  Colors.lightGreen,
  Colors.blue,
];

const List<String> kStoreIconList = [
  'assets/images/mcdonalds.svg',
  'assets/images/amazon.svg',
  'assets/images/apple.svg',
  'assets/images/target.svg',
  'assets/images/walmart.svg',
];
