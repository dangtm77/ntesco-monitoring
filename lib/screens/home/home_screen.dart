import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/components/main_drawer.dart';
import '../../sizeconfig.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(child: MainDrawer()),
      body: Body(),
    );
  }
}
