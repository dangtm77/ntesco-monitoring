import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "WorkSans",
    //appBarTheme: appBarTheme(),
    //textTheme: textTheme(),
    brightness: Brightness.light,
    //inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 5,
  );
  return InputDecorationTheme(
    labelStyle: TextStyle(
      fontSize: 18,
      color: kPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.all(10.0),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: OutlineInputBorder(),
  );
}
