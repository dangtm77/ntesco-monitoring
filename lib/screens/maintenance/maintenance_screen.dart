import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/sizeconfig.dart';

import 'components/maintenance/body.dart';

class MaintenanceScreen extends StatelessWidget {
  static String routeName = "/mt/maintenance";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: Body());
  }
}
