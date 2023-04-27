import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../models/mt/SystemReportModel.dart';

class ReplacementPageView extends StatefulWidget {
  final int id;
  final SystemReportModel model;
  const ReplacementPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<ReplacementPageView> createState() => _ReplacementPageViewState(id, model);
}

class _ReplacementPageViewState extends State<ReplacementPageView> {
  final int id;
  final SystemReportModel model;
  _ReplacementPageViewState(this.id, this.model);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
