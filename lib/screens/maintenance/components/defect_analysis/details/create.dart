// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

class DefectAnalysisDetailsCreateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis-details/create";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = int.parse(arguments['id'].toString());
    return Scaffold(drawerScrimColor: Colors.transparent, body: CreateBody(id: id));
  }
}

class CreateBody extends StatefulWidget {
  final int id;
  CreateBody({Key? key, required this.id}) : super(key: key);

  @override
  _CreatePageState createState() => new _CreatePageState(id);
}

class _CreatePageState extends State<CreateBody> {
  final int id;
  _CreatePageState(this.id);

  final _formKey = GlobalKey<FormBuilderState>();

  late List<XFile> _imageList = [];
  late bool isShowAdvance = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(_) => SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _header(_),
              _form(_),
            ],
          ),
        ),
      );

  Widget _header(BuildContext context) => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis_details.create_title".tr(),
          subtitle: "maintenance.defect_analysis_details.create_subtitle",
          buttonLeft: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pop(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
        ),
      );

  Widget _form(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(10),
            horizontal: getProportionateScreenWidth(10),
          ),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autoFocusOnValidationFailure: true,
            initialValue: {
              'idDefectAnalysis': id,
              'partName': null,
              'partQuantity': null,
              'partManufacturer': null,
              'partModel': null,
              'partSpecifications': null,
              'analysisProblemCause': null,
              'solution': null,
              'departmentInCharge': null,
              'executionTime': null,
              'note': null,
            },
            child: Column(
              children: <Widget>[
                editorForm("partName"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 16,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () => setState(() => isShowAdvance = !isShowAdvance),
                        child: Text('Thông tin khác', style: TextStyle(fontSize: 15, color: kPrimaryColor)),
                      ),
                    )
                  ],
                ),
                AnimatedOpacity(
                  opacity: isShowAdvance ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 700),
                  child: Visibility(
                    visible: isShowAdvance,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        editorForm("partManufacturer"),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: editorForm("partQuantity")),
                            SizedBox(width: 20),
                            Expanded(child: editorForm("partModel")),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                editorForm("partSpecifications"),
                SizedBox(height: 20),
                editorForm("analysisProblemCause"),
                SizedBox(height: 20),
                editorForm("solution"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: editorForm("departmentInCharge")),
                    SizedBox(width: 20),
                    Expanded(child: editorForm("executionTime")),
                  ],
                ),
                AnimatedOpacity(
                  opacity: isShowAdvance ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 700),
                  child: Visibility(
                    visible: isShowAdvance,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        editorForm("note"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hình ảnh đính kèm',
                      style: TextStyle(color: kPrimaryColor, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      ..._imageList.map((item) {
                        return Stack(
                          children: [
                            Card(
                              elevation: 8,
                              margin: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: SizedBox(
                                  width: 110.0,
                                  height: 110.0,
                                  child: Image.file(File(item.path), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: GestureDetector(
                                onTap: () => setState(() => _imageList.remove(item)),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Color.fromARGB(228, 244, 67, 54),
                                  child: Icon(Icons.close, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      GestureDetector(
                        onTap: _pickerOption,
                        child: Card(
                          elevation: 8,
                          margin: EdgeInsets.all(10),
                          color: kPrimaryColor,
                          child: SizedBox(
                              width: 120.0,
                              height: 120.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, size: 30.0, color: Colors.white),
                                  Text("Chọn ảnh", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: DefaultButton(
                        press: () => _formKey.currentState?.reset(),
                        text: "Đặt lại",
                        color: kTextColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 8,
                      child: DefaultButton(
                        text: 'Xác nhận thông tin',
                        color: kPrimaryColor,
                        press: () async => {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget editorForm(key) {
    switch (key) {
      case "partName":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Thông tin thiết bị'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "partManufacturer":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Nhà sản xuất',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partQuantity":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            labelText: 'Số lượng thiết bị',
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partModel":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Loại',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partSpecifications":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Thông số kỹ thuật',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "analysisProblemCause":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Phân tích sự cố'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "solution":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Giải pháp khắc phục sự cố'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "departmentInCharge":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Nhân sự / Phòng ban phụ trách'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "executionTime":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Thời gian thực hiện / xử lý'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "note":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Ghi chú khác',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> _pickerOption() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
              color: Colors.white,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Chọn hình ảnh đính kèm từ ...",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: TextButton(
                              style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: kPrimaryColor),
                              onPressed: () async {
                                var _image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 800, maxHeight: 800, preferredCameraDevice: CameraDevice.front);
                                if (_image != null) {
                                  setState(() {
                                    _imageList.add(_image);
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera, color: Colors.white, size: 60),
                                  SizedBox(height: 10),
                                  Text('CAMERA', style: TextStyle(fontSize: 16, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: TextButton(
                              style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: kPrimaryColor),
                              onPressed: () async {
                                await ImagePicker().pickMultiImage(imageQuality: 80, maxWidth: 800, maxHeight: 800).then((value) {
                                  if (value.length > 0) {
                                    setState(() {
                                      _imageList.addAll(value);
                                    });
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, color: Colors.white, size: 60),
                                  SizedBox(height: 10),
                                  Text('THƯ VIỆN', style: TextStyle(fontSize: 16, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
