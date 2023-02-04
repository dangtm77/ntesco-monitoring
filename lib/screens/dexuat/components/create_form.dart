// ignore_for_file: unnecessary_statements

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/dx/DanhMuc.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

class CreateForm extends StatefulWidget {
  final DanhMucModel danhmuc;
  CreateForm({Key? key, required this.danhmuc}) : super(key: key);

  @override
  _CreateFormState createState() => new _CreateFormState(danhmuc);
}

class _CreateFormState extends State<CreateForm> {
  final DanhMucModel danhmuc;
  _CreateFormState(this.danhmuc);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tieuDeController = TextEditingController();
  final TextEditingController _mucDichController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Text("THÔNG TIN CHUNG", textAlign: TextAlign.center, style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700, fontSize: 15.0)),
              Visibility(
                visible: danhmuc.formConfig.tieuDeLabel != null,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _tieuDeController,
                      readOnly: true,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: danhmuc.formConfig.tieuDeLabel.toString(),
                        hintText: danhmuc.formConfig.tieuDeLabel.toString(),
                      ).applyDefaults(inputDecorationTheme()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
