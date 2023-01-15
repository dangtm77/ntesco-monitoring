import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Quicksand",
    //appBarTheme: appBarTheme(),
    //textTheme: textTheme(),
    brightness: Brightness.light,
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 5,
  );
  return InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 18, color: kPrimaryColor, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: OutlineInputBorder(),
  );
}

// TextTheme textTheme() {
//   return TextTheme(
//     bodyText1: TextStyle(color: kTextColor),
//     bodyText2: TextStyle(color: kTextColor),
//   );
// }

// AppBarTheme appBarTheme() {
//   return AppBarTheme(
//     color: Colors.white,
//     elevation: 0,
//     brightness: Brightness.light,
//     iconTheme: IconThemeData(color: Colors.black),
//     textTheme: TextTheme(
//       headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
//     ),
//   );
// }
