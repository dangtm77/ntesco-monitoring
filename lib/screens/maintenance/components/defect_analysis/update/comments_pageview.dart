// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';

class CommentsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;
  const CommentsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<CommentsPageView> createState() => _CommentsPageViewState(id, model);
}

class _CommentsPageViewState extends State<CommentsPageView> {
  final int id;
  final DefectAnalysisModel model;
  _CommentsPageViewState(this.id, this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("ĐANG CẬP NHẬT ...")),
    );
  }
}
