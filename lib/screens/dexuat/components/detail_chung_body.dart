// ignore_for_file: unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';

class DetailChungBody extends StatefulWidget {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;

  const DetailChungBody({Key? key, required this.id, this.phieuDeXuat}) : super(key: key);

  @override
  _DetailChungBodyPageState createState() => new _DetailChungBodyPageState(id, phieuDeXuat);
}

class _DetailChungBodyPageState extends State<DetailChungBody> {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;
  final numberFormat = new NumberFormat("##,##0", "vi_VN");

  _DetailChungBodyPageState(this.id, this.phieuDeXuat);

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
    _tieuDeController.text = phieuDeXuat!.tieuDe;
    _mucDichController.text = phieuDeXuat!.mucDich;
    _noiDungController.text = phieuDeXuat!.noiDung;
    _tuNgayController.text = DateFormat('HH:mm dd/MM/yyyy').format(phieuDeXuat!.tuNgay);
    _denNgayController.text = DateFormat('HH:mm dd/MM/yyyy').format(phieuDeXuat!.denNgay);
    _giaTriController.text = phieuDeXuat!.giaTri != null ? numberFormat.format(phieuDeXuat!.giaTri) : "";
    _giaTri001Controller.text = phieuDeXuat!.giaTri001 != null ? numberFormat.format(phieuDeXuat!.giaTri001) : "";
    _giaTri002Controller.text = phieuDeXuat!.giaTri002 != null ? numberFormat.format(phieuDeXuat!.giaTri002) : "";
    _optionValue001Controller.text = phieuDeXuat!.optionValue001;
    _optionValue002Controller.text = phieuDeXuat!.optionValue002;
    _optionValue003Controller.text = phieuDeXuat!.optionValue003;
    _optionValue004Controller.text = phieuDeXuat!.optionValue004;
    _optionValue005Controller.text = phieuDeXuat!.optionValue005;
    _optionValue006Controller.text = phieuDeXuat!.optionValue006;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Text("THÔNG TIN CHUNG", style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
            Visibility(
              visible: phieuDeXuat!.formConfig.tieuDeLabel != null,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tieuDeController,
                    readOnly: true,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      labelText: phieuDeXuat!.formConfig.tieuDeLabel.toString(),
                      hintText: phieuDeXuat!.formConfig.tieuDeLabel.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.mucDichLabel != null,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _mucDichController,
                    readOnly: true,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: phieuDeXuat!.formConfig.mucDichLabel.toString(),
                      labelText: phieuDeXuat!.formConfig.mucDichLabel.toString(),
                    ).applyDefaults(inputDecorationTheme()),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.noiDungLabel != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _noiDungController,
                  readOnly: true,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.noiDungLabel.toString(),
                    hintText: phieuDeXuat!.formConfig.noiDungLabel.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.tuNgayLabel != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tuNgayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.tuNgayLabel.toString(),
                    hintText: phieuDeXuat!.formConfig.tuNgayLabel.toString(),
                    suffixIcon: Icon(Ionicons.calendar_outline, color: kPrimaryColor),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.denNgayLabel != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _denNgayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.denNgayLabel.toString(),
                    hintText: phieuDeXuat!.formConfig.denNgayLabel.toString(),
                    suffixIcon: Icon(Ionicons.calendar_outline, color: kPrimaryColor),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Text("THÔNG TIN KHÁC", style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
            Visibility(
              visible: phieuDeXuat!.formConfig.giaTriLabel != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _giaTriController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.giaTriLabel.toString(),
                    hintText: phieuDeXuat!.formConfig.giaTriLabel.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.giaTri001Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _giaTri001Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.giaTri001Label.toString(),
                    hintText: phieuDeXuat!.formConfig.giaTri001Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.giaTri002Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _giaTri002Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.giaTri002Label.toString(),
                    hintText: phieuDeXuat!.formConfig.giaTri002Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue001Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue001Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue001Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue001Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue002Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue002Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue002Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue002Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue003Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue003Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue003Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue003Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue004Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue004Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue004Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue004Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue005Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue005Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue005Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue005Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Visibility(
              visible: phieuDeXuat!.formConfig.optionValue006Label != null,
              child: Column(children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _optionValue006Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: phieuDeXuat!.formConfig.optionValue006Label.toString(),
                    hintText: phieuDeXuat!.formConfig.optionValue006Label.toString(),
                  ).applyDefaults(inputDecorationTheme()),
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  value: phieuDeXuat!.isQuanTrong,
                  onChanged: (bool? value) {},
                ),
                Text('Mức độ quan trọng'), //Checkbox
              ], //<Widget>[]
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     // Validate returns true if the form is valid, or false otherwise.
            //     if (_formKey.currentState!.validate()) {
            //       // If the form is valid, display a snackbar. In the real world,
            //       // you'd often call a server or save the information in a database.
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text('Processing Data')),
            //       );
            //     }
            //   },
            //   child: const Text('Submit'),
            // ),
          ],
        ),
      ),
    );
  }

  InputDecorationTheme inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: kTextColor),
      gapPadding: 5,
    );
    return InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 18,
        color: kPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: OutlineInputBorder(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
