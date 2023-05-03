import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import 'components/defect_analysis/body.dart';

class DefectAnalysisScreen extends StatelessWidget {
  static String routeName = "/mt/defect-analysis";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(body: Body());
  }
}
