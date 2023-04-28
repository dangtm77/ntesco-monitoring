// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';

import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/UserModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

import '../../../defect_analysis_screen.dart';

class SummaryPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;

  const SummaryPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  _SummaryPageViewState createState() => new _SummaryPageViewState(id, model);
}

class _SummaryPageViewState extends State<SummaryPageView> {
  final int id;
  final DefectAnalysisModel model;
  _SummaryPageViewState(this.id, this.model);

  final _formKey = GlobalKey<FormBuilderState>();
  late Future<ProjectModels> _listOfProjects;
  late Future<SystemModels> _listOfSystems;
  late Future<UserModels> _listOfUsers;

  Future<ProjectModels> _getListProjects() async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Common.Projects_GetList(options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return ProjectModels.fromJson(jsonDecode(response.body));
      else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  Future<SystemModels> _getListSystems(int id) async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(
        take: 0,
        skip: 0,
        sort: jsonEncode(sortOptions),
        filter: jsonEncode(filterOptions),
        requireTotalCount: 'true',
      );
      Response response = await Maintenance.Systems_GetList_ByProject(id, options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return SystemModels.fromJson(jsonDecode(response.body));
      else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  Future<UserModels> _getListUsers() async {
    try {
      List<dynamic> sortOptions = [
        {"selector": "phongBan_SapXep", "desc": "false"},
        {"selector": "chucDanh_SapXep", "desc": "true"},
      ];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Common.Users_GetList(options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return UserModels.fromJson(jsonDecode(response.body));
      else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  @override
  void initState() {
    _listOfProjects = _getListProjects();
    _listOfSystems = _getListSystems(model.project.id);
    _listOfUsers = _getListUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  'idProject': model.project.id,
                  'idSystem': model.idSystem,
                  'code': model.code,
                  'analysisDate': model.analysisDate,
                  'analysisBy': model.analysisBy,
                  'currentSuitation': model.currentSuitation,
                  'maintenanceStaff': model.maintenanceStaff,
                  'qcStaff': model.qcStaff,
                  'cncStaff': model.cncStaff,
                },
                child: Column(
                  children: <Widget>[
                    editorForm("idProject"),
                    SizedBox(height: 20),
                    editorForm("idSystem"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: editorForm("code")),
                        SizedBox(width: 10),
                        Expanded(child: editorForm("analysisDate")),
                      ],
                    ),
                    SizedBox(height: 20),
                    editorForm("analysisBy"),
                    SizedBox(height: 20),
                    editorForm("currentSuitation"),
                    SizedBox(height: 20),
                    editorForm("maintenanceStaff"),
                    SizedBox(height: 20),
                    editorForm("qcStaff"),
                    SizedBox(height: 20),
                    editorForm("cncStaff"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(flex: 2, child: DefaultButton(text: 'Hủy bỏ thông tin', icon: Icons.delete_forever, color: Colors.red, press: () async => deleteFunc(context, model))),
                        SizedBox(width: 10),
                        Expanded(flex: 3, child: DefaultButton(text: 'Cập nhật thông tin', icon: Icons.check_rounded, color: kPrimaryColor, press: () async => submitFunc(context))),
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
  }

  Widget editorForm(key) {
    switch (key) {
      case "idProject":
        return FutureBuilder(
          future: _listOfProjects,
          builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else {
              return FormBuilderDropdown<int>(
                name: 'idProject',
                enabled: false,
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                  label: Text.rich(TextSpan(children: [TextSpan(text: 'Dự án / Công trình'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                  hintText: "Vui lòng chọn thông tin...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _formKey.currentState!.fields['idProject']?.didChange(null),
                  ),
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.name}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(${item.location})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val,
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              );
            }
          },
        );
      case "idSystem":
        return FutureBuilder(
          future: _listOfSystems,
          builder: (BuildContext context, AsyncSnapshot<SystemModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else
              return FormBuilderDropdown<int>(
                name: 'idSystem',
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                  label: Text.rich(TextSpan(children: [TextSpan(text: 'Hệ thống cần phân tích'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                  hintText: "Vui lòng chọn thông tin...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _formKey.currentState!.fields['idSystem']?.didChange(null),
                  ),
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.name}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(Ngày bàn giao ${DateFormat("dd/MM/yyyy").format(item.dateAcceptance!)})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val,
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              );
          },
        );
      case "code":
        return FormBuilderTextField(
          name: "code",
          decoration: const InputDecoration(
            labelText: 'Mã hiệu',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "analysisDate":
        return FormBuilderDateTimePicker(
          name: "analysisDate",
          initialEntryMode: DatePickerEntryMode.calendar,
          inputType: InputType.date,
          format: DateFormat("dd/MM/yyyy"),
          decoration: InputDecoration(
            labelText: 'Ngày phân tích',
            hintText: "Vui lòng chọn thông tin...",
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['analysisDate']?.didChange(null);
              },
            ),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "analysisBy":
        return FutureBuilder(
          future: _listOfUsers,
          builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return LoadingWidget();
            else
              return FormBuilderDropdown<String>(
                name: 'analysisBy',
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                decoration: InputDecoration(
                    labelText: 'Nhân sự phân tích',
                    hintText: "Vui lòng chọn thông tin...",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _formKey.currentState!.fields['analysisByForm']?.didChange(null),
                    )).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.hoTen}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(${item.chucDanh})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val?.toString(),
              );
          },
        );
      case "currentSuitation":
        return FormBuilderTextField(
          name: "currentSuitation",
          decoration: InputDecoration(
            labelText: 'Hiện trạng',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "maintenanceStaff":
        return FutureBuilder(
          future: _listOfUsers,
          builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else
              return FormBuilderDropdown<String>(
                name: 'maintenanceStaff',
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                  labelText: 'Đại diện bộ phận Bảo trì',
                  hintText: "Vui lòng chọn thông tin...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => _formKey.currentState!.fields['maintenanceStaff']?.didChange(null),
                  ),
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.hoTen}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(${item.chucDanh})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val?.toString(),
              );
          },
        );
      case "qcStaff":
        return FutureBuilder(
          future: _listOfUsers,
          builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else
              return FormBuilderDropdown<String>(
                name: 'qcStaff',
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                    labelText: 'Đại diện bộ phận QC',
                    hintText: "Vui lòng chọn thông tin...",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _formKey.currentState!.fields['qcStaff']?.didChange(null),
                    )).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.hoTen}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(${item.chucDanh})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val?.toString(),
              );
          },
        );
      case "cncStaff":
        return FutureBuilder(
          future: _listOfUsers,
          builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else
              return FormBuilderDropdown<String>(
                name: 'cncStaff',
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                    labelText: 'Đại diện bộ phận C&C',
                    hintText: "Vui lòng chọn thông tin...",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => _formKey.currentState!.fields['cncStaff']?.didChange(null),
                    )).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "${item.hoTen}", style: TextStyle(fontWeight: FontWeight.w600)),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "(${item.chucDanh})", style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val?.toString(),
              );
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> submitFunc(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
      var defectAnalysisModel = {
        'idSystem': _formKey.currentState?.fields['idSystem']?.value,
        'code': _formKey.currentState?.fields['code']?.value,
        'analysisDate': _formKey.currentState?.fields['analysisDate']?.value.toIso8601String(),
        'analysisBy': _formKey.currentState?.fields['analysisBy']?.value,
        'currentSuitation': _formKey.currentState?.fields['currentSuitation']?.value,
        'maintenanceStaff': _formKey.currentState?.fields['maintenanceStaff']?.value,
        'qcStaff': _formKey.currentState?.fields['qcStaff']?.value,
        'cncStaff': _formKey.currentState?.fields['cncStaff']?.value,
      };
      await Maintenance.DefectAnalysis_Update(id, defectAnalysisModel).then((response) {
        ProgressHud.of(context)?.dismiss();
        if (response.statusCode >= 200 && response.statusCode <= 299)
          Util.showNotification(context, null, 'Cập nhật thông tin phân tích sự cố thành công', ContentType.success, 3);
        else
          Util.showNotification(context, null, response.body, ContentType.failure, 5);
      }).catchError((error, stackTrace) {
        ProgressHud.of(context)?.dismiss();
        Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
      });
    }
  }

  Future<void> deleteFunc(BuildContext context, DefectAnalysisModel item) async {
    showOkCancelAlertDialog(
      context: context,
      title: item.code,
      message: "Bạn có chắc chắn là muốn xóa bỏ thông tin này không?",
      okLabel: "Xóa bỏ",
      cancelLabel: "Đóng lại",
      isDestructiveAction: true,
    ).then((result) async {
      if (result == OkCancelResult.ok) {
        ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
        await Maintenance.DefectAnalysis_Delete(this.id).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299)
            Navigator.pushReplacementNamed(context, DefectAnalysisScreen.routeName);
          else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }
}
