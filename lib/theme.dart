import 'dart:ui';

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
  // OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(5),
  //   borderSide: BorderSide(color: kTextColor),
  //   //gapPadding: 5,
  // );
  // return InputDecorationTheme(
  //   labelStyle: TextStyle(
  //     fontSize: 18,
  //     color: kPrimaryColor,
  //     //fontWeight: FontWeight.w600,
  //   ),
  //   floatingLabelBehavior: FloatingLabelBehavior.auto,
  //   contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
  //   enabledBorder: outlineInputBorder,
  //   focusedBorder: outlineInputBorder,
  //   border: OutlineInputBorder(),
  // );
  return InputDecorationTheme(
    helperStyle: TextStyle(color: Color(0xFF95A1AC), fontSize: 15, fontStyle: FontStyle.italic),
    hintStyle: TextStyle(color: Color(0xFF95A1AC), fontSize: 15),
    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w600),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDBE2E7), width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDBE2E7), width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0x00000000), width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
    //fillColor: Color(0xFFDBE2E7),
    contentPadding: EdgeInsets.all(10.0),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    helperMaxLines: 5,
  );
}
