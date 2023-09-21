// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../models/maintenance/SystemReportModel.dart';

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
    return Container(
      child: Center(child: Text("ĐANG CẬP NHẬT ...")),
    );
  }
}
