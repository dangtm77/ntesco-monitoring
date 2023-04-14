// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  const CustomFloatingActionButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed as void Function()?,
      child: child,
    );
  }
}
