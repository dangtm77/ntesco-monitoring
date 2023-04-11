// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _header(),
              _form(context),
            ],
          ),
        ),
      );

  Widget _header() => Container(
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
        child: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
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
                      SizedBox(height: 20),
                      editorForm("partManufacturer"),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: editorForm("partQuantity")),
                          SizedBox(width: 10),
                          Expanded(child: editorForm("partModel")),
                        ],
                      ),
                      SizedBox(height: 20),
                      editorForm("partSpecifications"),
                      SizedBox(height: 20),
                      // editorForm("currentSuitation"),
                      // SizedBox(height: 20),
                      // editorForm("maintenanceStaff"),
                      // SizedBox(height: 20),
                      // editorForm("qcStaff"),
                      // SizedBox(height: 20),
                      // editorForm("cncStaff"),
                      // SizedBox(height: 20),
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
            labelText: 'Tên thiết bị',
            hintText: "Vui lòng nhập thông tin...",
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
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "partQuantity":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Số lượng',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "partModel":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Loại',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "partSpecifications":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Thông số kỹ thuật',
            hintText: "Vui lòng nhập thông tin...",
            contentPadding: EdgeInsets.fromLTRB(15, 25, 15, 0),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
