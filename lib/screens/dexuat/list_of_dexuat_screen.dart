import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'components/list_body.dart';

class ListOfDeXuatScreen extends StatelessWidget {
  static String routeName = "/dexuat";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: Body());
  }
}
