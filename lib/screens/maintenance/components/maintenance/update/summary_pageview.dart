// ignore_for_file: implementation_imports

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../models/maintenance/SystemReportModel.dart';

class SummaryPageView extends StatefulWidget {
  final int id;
  final SystemReportModel model;
  const SummaryPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<SummaryPageView> createState() => _SummaryPageViewState(id, model);
}

class _SummaryPageViewState extends State<SummaryPageView> {
  final int id;
  final SystemReportModel model;
  _SummaryPageViewState(this.id, this.model);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
