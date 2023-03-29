import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import 'components/defect_analysis/body.dart';

class MaintenanceDefectAnalysisScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: Body());
  }
}
