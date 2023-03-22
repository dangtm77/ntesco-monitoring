import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.error_outline_rounded,
      color: kPrimaryColor,
      size: 40,
    );
  }
}
