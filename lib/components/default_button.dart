import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({Key? key, required this.text, this.color, this.press}) : super(key: key);

  final String text;
  final Color? color;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: color ?? kPrimaryColor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
      ),
    );
  }
}
