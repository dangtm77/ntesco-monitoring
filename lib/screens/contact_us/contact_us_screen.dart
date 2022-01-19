import 'package:flutter/material.dart'; 
import '../../size_config.dart';
import 'components/body.dart'; 

class ContactUsScreen extends StatelessWidget {
  static String routeName = "/contact-me";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawerScrimColor: Colors.transparent, 
      body: Body(),
    );
  }
}
