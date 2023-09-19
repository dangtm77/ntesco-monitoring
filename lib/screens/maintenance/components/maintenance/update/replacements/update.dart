import 'package:adaptive_dialog/adaptive_dialog.dart';
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
import 'package:ntesco_smart_monitoring/sizeconfig.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

import '../../../../../../components/default_button.dart';
import '../../../../../../components/state_widget.dart';
import '../../../../../../models/mt/SystemReportReplacementsModel.dart';
import '../../../../../../repository/mt/systyem_report_replacements.dart';

class SystemReportReplacementsUpdateScreen extends StatelessWidget {
  final int id;
  const SystemReportReplacementsUpdateScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: UpdateBody(id: id));
  }
}

class UpdateBody extends StatefulWidget {
  final int id;
  UpdateBody({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateBodyState createState() => new _UpdateBodyState(id);
}

class _UpdateBodyState extends State<UpdateBody> {
  final int id;
  _UpdateBodyState(this.id);

  final _formKey = GlobalKey<FormBuilderState>();
  late Future<SystemReportReplacementsModel> _systemReportReplacement;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _systemReportReplacement = MaintenanceSystemReportReplacementsRepository.getDetail(id);
    super.initState();
  }

  @override
  Widget build(_) => Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _header(_),
                _main(_),
              ],
            ),
          ),
        ),
      );

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: TopHeaderSub(
        title: "Cập nhật thông tin".toUpperCase(),
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

  Widget _main(BuildContext context) {
    return Expanded(
        child: FutureBuilder<SystemReportReplacementsModel>(
      future: _systemReportReplacement,
      builder: (BuildContext context, AsyncSnapshot<SystemReportReplacementsModel> snapshot) {
        if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) return LoadingWidget();
        if (!(snapshot.hasData && snapshot.data != null)) return NoDataWidget();

        return _form(context, snapshot.data!);
      },
    ));
  }

  Widget _form(BuildContext context, SystemReportReplacementsModel model) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(10),
        horizontal: getProportionateScreenWidth(10),
      ),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: {
          'name': model.name,
          'model': model.model,
          'unit': model.unit,
          'quantity': model.quantity.toString(),
          'stateOfEmergency': [model.stateOfEmergency],
          'sortIndex': model.sortIndex.toString(),
          'specifications': model.specifications,
        },
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
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
            DefaultButton(text: 'Hủy bỏ thông tin', icon: Icons.delete_forever, color: Colors.red, press: () async => removeFunc(context, model))
          ],
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
          'name': _formKey.currentState?.fields['name']?.value,
          'model': _formKey.currentState?.fields['model']?.value,
          'unit': _formKey.currentState?.fields['unit']?.value,
          'quantity': _formKey.currentState?.fields['quantity']?.value,
          'specifications': _formKey.currentState?.fields['specifications']?.value,
          'stateOfEmergency': _formKey.currentState?.fields['stateOfEmergency']?.value.first ?? false,
          'sortIndex': _formKey.currentState?.fields['sortIndex']?.value,
        };

        await MaintenanceSystemReportReplacementsRepository.update(id, model).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, null, 'Cập nhật thông tin thiết bị cần thay thế thành công', ContentType.success, 3);
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

  Future<void> removeFunc(BuildContext context, dynamic item) async {
    showOkCancelAlertDialog(
      context: context,
      title: "XÁC NHẬN THÔNG TIN",
      message: "Bạn có chắc chắn là muốn xóa bỏ thông tin này không?",
      okLabel: "Xóa bỏ",
      cancelLabel: "Đóng lại",
      isDestructiveAction: true,
    ).then((result) async {
      if (result == OkCancelResult.ok) {
        ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
        await MaintenanceSystemReportReplacementsRepository.delete(item.id).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Navigator.of(context).pop();
            Util.showNotification(context, 'Xóa bỏ thành công', response.body, ContentType.success, 3);
          } else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
