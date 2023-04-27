import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../models/mt/SystemReportModel.dart';

class ReviewsPageView extends StatefulWidget {
  final int id;
  final SystemReportModel model;
  const ReviewsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<ReviewsPageView> createState() => _ReviewsPageViewState(id, model);
}

class _ReviewsPageViewState extends State<ReviewsPageView> {
  final int id;
  final SystemReportModel model;
  _ReviewsPageViewState(this.id, this.model);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
