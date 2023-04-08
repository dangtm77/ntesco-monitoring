import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import 'components/plan/body.dart';

class PlanScreen extends StatelessWidget {
  static String routeName = "/mt/plan";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: Body());
  }
}
