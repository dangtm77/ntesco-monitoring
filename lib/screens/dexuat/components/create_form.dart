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
  final TextEditingController _noiDungController = TextEditingController();
  final TextEditingController _tuNgayController = TextEditingController();
  final TextEditingController _denNgayController = TextEditingController();
  final TextEditingController _giaTriController = TextEditingController();
  final TextEditingController _giaTri001Controller = TextEditingController();
  final TextEditingController _giaTri002Controller = TextEditingController();
  final TextEditingController _optionValue001Controller = TextEditingController();
  final TextEditingController _optionValue002Controller = TextEditingController();
  final TextEditingController _optionValue003Controller = TextEditingController();
  final TextEditingController _optionValue004Controller = TextEditingController();
  final TextEditingController _optionValue005Controller = TextEditingController();
  final TextEditingController _optionValue006Controller = TextEditingController();

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
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: danhmuc.formConfig.tieuDeLabel.toString(),
                        hintText: danhmuc.formConfig.tieuDeLabel.toString() + "...",
                      ).applyDefaults(inputDecorationTheme()),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: danhmuc.formConfig.mucDichLabel != null,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _mucDichController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: danhmuc.formConfig.mucDichLabel.toString(),
                        hintText: danhmuc.formConfig.mucDichLabel.toString() + "...",
                      ).applyDefaults(inputDecorationTheme()),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: danhmuc.formConfig.noiDungLabel != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _noiDungController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.noiDungLabel.toString(),
                      hintText: danhmuc.formConfig.noiDungLabel.toString() + "...",
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.tuNgayLabel != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tuNgayController,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.tuNgayLabel.toString(),
                      hintText: danhmuc.formConfig.tuNgayLabel.toString() + "...",
                      suffixIcon: Icon(Ionicons.calendar_outline, color: kPrimaryColor),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.denNgayLabel != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _denNgayController,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.denNgayLabel.toString(),
                      hintText: danhmuc.formConfig.denNgayLabel.toString() + "...",
                      suffixIcon: Icon(Ionicons.calendar_outline, color: kPrimaryColor),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Text("THÔNG TIN KHÁC", textAlign: TextAlign.center, style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700, fontSize: 15.0)),
              Visibility(
                visible: danhmuc.formConfig.giaTriLabel != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _giaTriController,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.giaTriLabel.toString(),
                      hintText: danhmuc.formConfig.giaTriLabel.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.giaTri001Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _giaTri001Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.giaTri001Label.toString(),
                      hintText: danhmuc.formConfig.giaTri001Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.giaTri002Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _giaTri002Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.giaTri002Label.toString(),
                      hintText: danhmuc.formConfig.giaTri002Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue001Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue001Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue001Label.toString(),
                      hintText: danhmuc.formConfig.optionValue001Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue002Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue002Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue002Label.toString(),
                      hintText: danhmuc.formConfig.optionValue002Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue003Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue003Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue003Label.toString(),
                      hintText: danhmuc.formConfig.optionValue003Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue004Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue004Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue004Label.toString(),
                      hintText: danhmuc.formConfig.optionValue004Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue005Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue005Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue005Label.toString(),
                      hintText: danhmuc.formConfig.optionValue005Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
              ),
              Visibility(
                visible: danhmuc.formConfig.optionValue006Label != null,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _optionValue006Controller,
                    decoration: InputDecoration(
                      labelText: danhmuc.formConfig.optionValue006Label.toString(),
                      hintText: danhmuc.formConfig.optionValue006Label.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ]),
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
