import 'package:flutter/material.dart';

import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';

class DetailsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;

  const DetailsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  _DetailsPageViewState createState() => new _DetailsPageViewState(id, model);
}

class _DetailsPageViewState extends State<DetailsPageView> {
  final int id;
  final DefectAnalysisModel model;
  _DetailsPageViewState(this.id, this.model);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(model.code));
  }
}
