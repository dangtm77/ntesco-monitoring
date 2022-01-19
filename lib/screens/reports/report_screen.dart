import 'package:flutter/material.dart'; 
import '../../size_config.dart';
import 'components/body.dart';

class ReportsScreen extends StatelessWidget {
  static String routeName = "/reports";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      body: Body(),
    );
  }
}
