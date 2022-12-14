import 'package:flutter/material.dart'; 
import '../../size_config.dart';
import 'components/body.dart';

class DeXuatScreen extends StatelessWidget {
  static String routeName = "/dexuat";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      body: Body(),
    );
  }
}
