// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

import '../../../../../../repository/mt/systyem_report_replacements.dart';

class SystemReportReplacementsCreateScreen extends StatelessWidget {
  final int id;
  const SystemReportReplacementsCreateScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: TopHeaderSub(
        title: "Thêm mới thông tin".toUpperCase(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pop(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 25.0)],
          ),
        ),
        buttonRight: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async => submitFunc(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.save_outline, color: kPrimaryColor, size: 25.0)],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(10),
        ),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autoFocusOnValidationFailure: true,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: editorForm("sortIndex"), flex: 2),
                  SizedBox(width: 20),
                  Expanded(child: editorForm("name"), flex: 10),
                ],
              ),
              SizedBox(height: 20),
              editorForm("model"),
              SizedBox(height: 20),
              editorForm("specifications"),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: editorForm("unit")),
                  SizedBox(width: 20),
                  Expanded(child: editorForm("quantity")),
                ],
              ),
              SizedBox(height: 20),
              editorForm("stateOfEmergency"),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget editorForm(key) {
    switch (key) {
      case "name":
        return FormBuilderTextField(
          name: key,
          decoration: InputDecoration(
            hintText: "common.text_input_hint".tr(),
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: "maintenance.system_report_replacements.name.label".tr()),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation.required_select".tr())]),
        );
      case "quantity":
        return FormBuilderTextField(
          name: key,
          decoration: InputDecoration(
            hintText: "common.text_input_hint".tr(),
            labelText: "maintenance.system_report_replacements.quantity.label".tr(),
          ).applyDefaults(inputDecorationTheme()),
          valueTransformer: (value) => int.parse(value!),
          keyboardType: TextInputType.number,
          initialValue: "1",
        );
      case "model":
        return FormBuilderTextField(
          name: key,
          decoration: InputDecoration(
            labelText: 'maintenance.system_report_replacements.model.label'.tr(),
            hintText: "common.text_input_hint".tr(),
          ).applyDefaults(inputDecorationTheme()),
        );
      case "unit":
        return FormBuilderTextField(
          name: key,
          decoration: InputDecoration(
            labelText: "maintenance.system_report_replacements.unit.label".tr(),
            hintText: "common.text_input_hint".tr(),
          ).applyDefaults(inputDecorationTheme()),
        );
      case "specifications":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "maintenance.system_report_replacements.specifications.label".tr(),
            hintText: "common.text_input_hint".tr(),
          ).applyDefaults(inputDecorationTheme()),
        );
      case "stateOfEmergency":
        return FormBuilderFilterChip<bool>(
          name: key,
          decoration: InputDecoration(
            labelText: "maintenance.system_report_replacements.state_of_emergency.label".tr(),
            hintText: "common.text_select_hint".tr(),
          ).applyDefaults(inputDecorationTheme()),
          options: [
            FormBuilderChipOption(value: true, child: Text("maintenance.system_report_replacements.state_of_emergency.option_01".tr())),
            FormBuilderChipOption(value: false, child: Text("maintenance.system_report_replacements.state_of_emergency.option_02".tr())),
          ],
          checkmarkColor: kPrimaryColor,
          elevation: 6,
          spacing: 10,
          maxChips: 1,
          initialValue: [false],
        );

      case "sortIndex":
        return FormBuilderTextField(
          name: key,
          decoration: InputDecoration(
            hintText: "common.text_input_hint".tr(),
            labelText: "maintenance.system_report_replacements.sort_index.label".tr(),
          ).applyDefaults(inputDecorationTheme()),
          valueTransformer: (value) => int.parse(value!),
          keyboardType: TextInputType.number,
          initialValue: "1",
        );
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> submitFunc(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      ProgressHud.of(context)?.show(ProgressHudType.loading, "state.waiting".tr());
      try {
        var model = <String, dynamic>{
          'idSystemReport': id,
          'name': _formKey.currentState?.fields['name']?.value,
          'model': _formKey.currentState?.fields['model']?.value,
          'unit': _formKey.currentState?.fields['unit']?.value,
          'quantity': _formKey.currentState?.fields['quantity']?.value,
          'specifications': _formKey.currentState?.fields['specifications']?.value,
          'stateOfEmergency': _formKey.currentState?.fields['stateOfEmergency']?.value.first ?? false,
          'sortIndex': _formKey.currentState?.fields['sortIndex']?.value,
        };

        await MaintenanceSystemReportReplacementsRepository.create(model).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, null, 'Khởi tạo thêm thông tin thiết bị cần thay thế thành công', ContentType.success, 3);
            Navigator.of(context).pop();
          } else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      } on Exception catch (e) {
        ProgressHud.of(context)?.dismiss();
        Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: ${e.toString()}", ContentType.failure, 5);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
