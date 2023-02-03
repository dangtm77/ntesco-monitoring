// ignore_for_file: unnecessary_statements

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/dx/DanhMuc.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';

class CreateForm extends StatefulWidget {
  final DanhMucModel danhmuc;
  CreateForm({Key? key, required this.danhmuc}) : super(key: key);

  @override
  _CreateFormState createState() => new _CreateFormState(danhmuc);
}

class _CreateFormState extends State<CreateForm> {
  final DanhMucModel danhmuc;
  _CreateFormState(this.danhmuc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(danhmuc.moTa.toString()),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
