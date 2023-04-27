// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemConfigModel.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

import '../../../../components/state_widget.dart';
import '../../../../components/top_header.dart';
import '../../../../constants.dart';
import '../../../../helper/string.dart';
import '../../../../models/mt/SystemModel.dart';
import '../../../../models/mt/SystemReportReplacementModel.dart';
import '../../../../repository/mt/systemConfigs.dart';
import '../../../../size_config.dart';
import '../../../../theme.dart';

class MaintenanceCreateScreen extends StatelessWidget {
  final SystemModel systemModel;
  const MaintenanceCreateScreen({Key? key, required this.systemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: _MaintenanceCreateBody(systemModel: systemModel));
  }
}

class _MaintenanceCreateBody extends StatefulWidget {
  final SystemModel systemModel;
  _MaintenanceCreateBody({Key? key, required this.systemModel}) : super(key: key);

  @override
  _MaintenanceCreateBodyState createState() => new _MaintenanceCreateBodyState(systemModel);
}

class _MaintenanceCreateBodyState extends State<_MaintenanceCreateBody> {
  final SystemModel systemModel;
  _MaintenanceCreateBodyState(this.systemModel);

  late int _currentIndex;
  late PageController _pageController = new PageController();
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<SystemConfigModels> _listOfSystemConfigs;
  late List<SystemReportReplacementModel> _listOfSystemReportReplacement;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    _listOfSystemConfigs = MaintenanceSystemConfigsRepository.getListSystemConfigs(systemModel.id);
    _listOfSystemReportReplacement = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_headers(context), _form(context)],
          ),
        ),
      ),
    );
  }

  Widget _headers(BuildContext context) {
    return Container(
      child: TopHeaderSub(
        title: "maintenance.maintenance.create_title".tr(),
        subtitle: systemModel.name.toString(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pop(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
        buttonRight: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async => submitFunc(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.save_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Expanded(
      child: FutureBuilder<SystemConfigModels>(
        future: _listOfSystemConfigs,
        builder: (BuildContext context, AsyncSnapshot<SystemConfigModels> snapshot) {
          if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
          if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)) return LoadingWidget();
          if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget();

          List<SystemConfigModel> listData = snapshot.data!.data;
          listData.add(new SystemConfigModel(id: 0, groupTitle: 'Thông tin chung', groupSortIndex: 0, idSystem: 0, idSystemSpecification: 0, isActive: true, isDelete: false, isRequired: true));

          return FormBuilder(
            key: _formKey,
            child: AnimationLimiter(
              child: GroupedListView<dynamic, dynamic>(
                elements: listData,
                groupBy: (element) => "${element.groupSortIndex + 1}. ${element.groupTitle}",
                groupSeparatorBuilder: (dynamic value) => Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        value.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (BuildContext context, dynamic value) {
                  var item = value as SystemConfigModel;
                  return AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: _formEditor(item),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _formEditor(SystemConfigModel model) {
    if (model.id == 0) {
      return Column(
        children: [
          FormBuilderTextField(
            name: "fieldMain-code",
            decoration: InputDecoration(
              label: Text.rich(TextSpan(children: [TextSpan(text: 'Mã hiệu'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
              hintText: "Vui lòng nhập thông tin...",
              suffix: IconButton(
                padding: EdgeInsets.only(right: 5.0),
                iconSize: 20,
                constraints: BoxConstraints(),
                icon: Icon(Ionicons.refresh),
                onPressed: () => _formKey.currentState!.fields['fieldMain-code']?.didChange(StringHelper.autoGenCode(3, 7, '#')),
              ),
            ).applyDefaults(inputDecorationTheme()),
            initialValue: StringHelper.autoGenCode(3, 7, '#'),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation.required".tr())]),
          ),
          SizedBox(height: 20),
          FormBuilderFilterChip<int>(
            name: "fieldMain-type",
            decoration: InputDecoration(
              labelText: "Loại hình dịch vụ",
              hintText: "common.hint_text_select".tr(),
            ).applyDefaults(inputDecorationTheme()),
            options: [
              FormBuilderChipOption(value: 1, child: Text('Bảo hành')),
              FormBuilderChipOption(value: 2, child: Text('Hợp đồng bảo trì')),
              FormBuilderChipOption(value: 3, child: Text('Yêu cầu khác')),
            ],
            checkmarkColor: kPrimaryColor,
            elevation: 6,
            spacing: 10,
            maxChips: 1,
          )
        ],
      );
    } else {
      Widget result = SizedBox.shrink();
      Widget _label = Text.rich(
        TextSpan(
          children: [
            TextSpan(text: model.specification!.title.toString()),
            WidgetSpan(child: Visibility(visible: model.isRequired, child: Text(' (*)', style: TextStyle(color: Colors.red)))),
          ],
        ),
      );
      String? _helperText;
      if (model.specification!.helpText != null) _helperText = "Ghi chú: ${model.specification!.helpText}";
      if (model.standardValues != null) _helperText = "${_helperText != null ? '$_helperText | ' : ''}Tiêu chuẩn: ${model.standardValues}";

      switch (model.specification!.dataType) {
        case "TextBox":
          result = FormBuilderTextField(
            name: 'fieldSub-${model.id}',
            decoration: InputDecoration(
              label: _label,
              hintText: "common.hint_text_input".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            validator: (model.isRequired) ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation.required".tr())]) : null,
          );
          break;
        case "TextArea":
          result = FormBuilderTextField(
            name: 'fieldSub-${model.id}',
            maxLines: 5,
            decoration: InputDecoration(
              label: _label,
              hintText: "common.hint_text_input".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            validator: (model.isRequired) ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation.required".tr())]) : null,
          );
          break;
        case "CheckBox1":
          if (model.specification!.dataValues != null)
            result = FormBuilderFilterChip<String>(
              name: 'fieldSub-${model.id}',
              decoration: InputDecoration(
                label: _label,
                hintText: "common.hint_text_select".tr(),
                helperText: _helperText,
              ).applyDefaults(inputDecorationTheme()),
              options: [
                ...model.specification!.dataValues!.split(',').map((value) {
                  return FormBuilderChipOption(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
              validator: (model.isRequired) ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation_select.required".tr())]) : null,
              checkmarkColor: kPrimaryColor,
              elevation: 6,
              spacing: 10,
              maxChips: 1,
            );
          break;
        case "CheckBox2":
          if (model.specification!.dataValues != null)
            result = FormBuilderCheckboxGroup<String>(
              name: 'fieldSub-${model.id}',
              decoration: InputDecoration(
                label: _label,
                hintText: "common.hint_text_select".tr(),
                helperText: _helperText,
              ).applyDefaults(inputDecorationTheme()),
              options: [
                ...model.specification!.dataValues!.split(',').map((value) {
                  return FormBuilderChipOption(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
              validator: (model.isRequired) ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation_select.required".tr())]) : null,
              separator: const VerticalDivider(width: 10, thickness: 5),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          break;
        case "SelectBox":
          if (model.specification!.dataValues != null)
            result = FormBuilderDropdown<String>(
              name: 'fieldSub-${model.id}',
              decoration: InputDecoration(
                label: _label,
                hintText: "common.hint_text_select".tr(),
                helperText: _helperText,
              ).applyDefaults(inputDecorationTheme()),
              items: [
                ...model.specification!.dataValues!.split(',').map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
              validator: (model.isRequired) ? FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "validation_select.required".tr())]) : null,
              elevation: 6,
            );
          break;
        default:
          break;
      }
      return result;
    }
  }

  Future<void> submitFunc(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState?.saveAndValidate() ?? false) {
      await showOkCancelAlertDialog(
        context: context,
        title: "XÁC NHẬN THÔNG TIN",
        message: "Bạn có chắc chắn là muốn khởi tạo thông tin về báo cáo tình trạng bảo trì hệ thống không?",
        okLabel: "Xác nhận",
        cancelLabel: "Đóng",
        isDestructiveAction: true,
      ).then((result) async {
        if (result == OkCancelResult.ok) {
          ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");

          if (formState != null) {
            final fields = formState.fields;
            var _systemConfigModel = [];
            var _type = [];
            var _code = StringHelper.autoGenCode(3, 7, '#');
            for (final field in fields.values) {
              if (field.widget.name == "fieldMain-code" || field.widget.name == "fieldMain-type") {
                _code = _formKey.currentState?.fields['fieldMain-code']?.value;
                _type = _formKey.currentState?.fields['fieldMain-type']?.value;
              } else {
                int _id = int.parse(field.widget.name.split('-').last);
                String _value = field.value.toString();
                _systemConfigModel.add({'idSystemConfig': _id, 'inputValue': _value});
              }
            }

            Map<String, dynamic> _systemReportModel = {
              'idSystem': systemModel.id,
              'code': _code,
              'type': (_type != null && _type.length > 0) ? _type.first : null,
              'details': _systemConfigModel,
            };

            await Maintenance.SystemReports_Create(jsonEncode(_systemReportModel)).then((response) {
              ProgressHud.of(context)?.dismiss();
              if (response.statusCode >= 200 && response.statusCode <= 299) {
                Util.showNotification(context, null, 'Khởi tạo báo cáo bảo trì hệ thống thành công', ContentType.success, 2);
                Navigator.of(context).pop();
              } else
                Util.showNotification(context, null, response.body, ContentType.failure, 5);
            }).catchError((error, stackTrace) {
              ProgressHud.of(context)?.dismiss();
              Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
            });
          }
        }
      });
    }
  }
}
