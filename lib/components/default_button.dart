// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants.dart';

// class DefaultButton extends StatelessWidget {
//   const DefaultButton({
//     Key? key,
//     required this.text,
//     this.color,
//     this.press,
//   }) : super(key: key);

//   final String text;
//   final Color? color;
//   final Function? press;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 40,
//       child: TextButton(
//         style: TextButton.styleFrom(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           backgroundColor: color ?? kPrimaryColor,
//         ),
//         onPressed: press as void Function()?,
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.8),
//         ),
//       ),
//     );
//   }
// }

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.icon,
    required this.text,
    this.color,
    this.press,
    this.height,
    this.width,
  }) : super(key: key);

  final IconData? icon;
  final String text;
  final Color? color;
  final Function? press;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40.0,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: color ?? kPrimaryColor,
        ),
        onPressed: press as void Function()?,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null ? Icon(icon, size: 20) : SizedBox.shrink(),
            icon != null ? SizedBox(width: 5) : SizedBox.shrink(),
            Text(text, style: TextStyle(fontSize: 15.0)),
          ],
        ),
      ),
    );
  }
}
