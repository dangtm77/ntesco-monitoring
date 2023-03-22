import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import 'components/body.dart';

class MaintenanceScreen extends StatelessWidget {
  static String routeName = "/maintenance";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: Body());
  }
}
