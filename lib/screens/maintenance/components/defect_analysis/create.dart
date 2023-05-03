import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/string.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/UserModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/repository/common/projects.dart';
import 'package:ntesco_smart_monitoring/repository/common/users.dart';
import 'package:ntesco_smart_monitoring/repository/mt/systems.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefectAnalysisCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: _DefectAnalysisCreateBody());
  }
}

class _DefectAnalysisCreateBody extends StatefulWidget {
  _DefectAnalysisCreateBody({Key? key}) : super(key: key);

  @override
  _DefectAnalysisCreateBodyState createState() => new _DefectAnalysisCreateBodyState();
}

class _DefectAnalysisCreateBodyState extends State<_DefectAnalysisCreateBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<ProjectModels> _listOfProjects;
  late Future<SystemModels> _listOfSystems;
  late Future<UserModels> _listOfUsers;
  late int _projectCurrent = 0;

  Future<void> _getLocalStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;
      _listOfProjects = CommonProjectsRepository.getListProjects(null);
      _listOfSystems = MaintenanceSystemsRepository.getListSystemsByIDProject(_projectCurrent, null);
      _listOfUsers = CommonUsersRepository.getListUsers(null);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocalStore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _header(context),
            _form(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis.create_title".tr(),
          subtitle: "maintenance.defect_analysis.create_subtitle",
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
              children: [Icon(Icons.save_outlined, color: kPrimaryColor, size: 25.0)],
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
                    'idProject': _projectCurrent != 0 ? _projectCurrent : null,
                    'idSystem': null,
                    'code': StringHelper.autoGenCode(3, 7, '#'),
                    'analysisDate': DateTime.now(),
                    'analysisBy': 'admin',
                    'currentSuitation': null,
                    'maintenanceStaff': null,
                    'qcStaff': null,
                    'cncStaff': null,
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
                      DefaultButton(
                        press: () => _formKey.currentState?.reset(),
                        icon: Icons.restart_alt_outlined,
                        text: "button.reset".tr(),
                        color: kTextColor,
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
      case "idProject":
        return FutureBuilder(
          future: _listOfProjects,
          builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
            if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
            if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else {
              return FormBuilderDropdown<int>(
                name: 'idProject',
                enabled: false,
                menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                decoration: InputDecoration(
                  label: Text.rich(TextSpan(children: [TextSpan(text: 'Dự án / Công trình'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                  hintText: "Vui lòng chọn thông tin...",
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          "${item.name} (${item.location})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: kNormalFontSize),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (dynamic val) {
                  if (val != null) {
                    _formKey.currentState!.fields['idSystem']?.didChange(null);
                    setState(() {
                      _listOfSystems = MaintenanceSystemsRepository.getListSystemsByIDProject(val, null);
                    });
                  }
                },
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
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                decoration: InputDecoration(
                  label: Text.rich(TextSpan(children: [TextSpan(text: 'Hệ thống cần phân tích'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                  hintText: "Vui lòng chọn thông tin...",
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          "${item.name} (Bàn giao ${DateFormat("dd/MM/yyyy").format(item.dateAcceptance!)})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: kNormalFontSize),
                        ),
                      ),
                    )
                    .toList(),
                valueTransformer: (val) => val,
              );
          },
        );
      case "code":
        return FormBuilderTextField(
          name: "code",
          decoration: const InputDecoration(
            label: Text.rich(TextSpan(children: [TextSpan(text: 'Mã hiệu'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
          style: TextStyle(fontSize: kNormalFontSize),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "analysisDate":
        return FormBuilderDateTimePicker(
          name: "analysisDate",
          initialEntryMode: DatePickerEntryMode.calendar,
          inputType: InputType.date,
          format: DateFormat("dd/MM/yyyy"),
          decoration: InputDecoration(
            label: Text.rich(TextSpan(children: [TextSpan(text: 'Ngày phân tích'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
            hintText: "Vui lòng chọn thông tin...",
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['analysisDate']?.didChange(null);
              },
            ),
          ).applyDefaults(inputDecorationTheme()),
          style: TextStyle(fontSize: kNormalFontSize),
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
                  label: Text.rich(TextSpan(children: [TextSpan(text: 'Nhân sự phân tích'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                  hintText: "Vui lòng chọn thông tin...",
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text(
                          "${item.hoTen} (${item.chucDanh})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: kNormalFontSize),
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
          style: TextStyle(fontSize: kNormalFontSize),
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
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 49)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Row(
                          children: [
                            Text(
                              "${item.hoTen} (${item.chucDanh})",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: kNormalFontSize),
                            )
                          ],
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
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 28)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text(
                          "${item.hoTen} (${item.chucDanh})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: kNormalFontSize),
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
                ).applyDefaults(inputDecorationTheme()),
                items: snapshot.data!.data
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 41)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.username.toString(),
                        child: Text(
                          "${item.hoTen} (${item.chucDanh})",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: kNormalFontSize),
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
      await showOkCancelAlertDialog(
        context: context,
        title: "XÁC NHẬN THÔNG TIN",
        message: "Bạn có chắc chắn là muốn khởi tạo thông tin này không?\n\r\n\rLưu ý: Nếu thông tin đại diện của các bộ phận không được chọn hệ thống sẽ tự động lấy nhân sự có vai trò cao nhất trong phòng/bộ phận",
        okLabel: "Xác nhận",
        cancelLabel: "Đóng",
        isDestructiveAction: true,
      ).then((result) async {
        if (result == OkCancelResult.ok) {
          ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
          var model = {
            'idProject': _formKey.currentState?.fields['idProject']?.value,
            'idSystem': _formKey.currentState?.fields['idSystem']?.value,
            'code': _formKey.currentState?.fields['code']?.value,
            'analysisDate': _formKey.currentState?.fields['analysisDate']?.value.toIso8601String(),
            'analysisBy': _formKey.currentState?.fields['analysisBy']?.value,
            'currentSuitation': _formKey.currentState?.fields['currentSuitation']?.value,
            'maintenanceStaff': _formKey.currentState?.fields['maintenanceStaff']?.value,
            'qcStaff': _formKey.currentState?.fields['qcStaff']?.value,
            'cncStaff': _formKey.currentState?.fields['cncStaff']?.value,
          };
          await Maintenance.DefectAnalysis_Create(jsonEncode(model)).then((response) {
            ProgressHud.of(context)?.dismiss();
            if (response.statusCode >= 200 && response.statusCode <= 299) {
              Util.showNotification(context, null, 'Khởi tạo thông tin báo cáo phân tích sự cố thành công', ContentType.success, 3);
              Navigator.of(context).pop();
            } else
              Util.showNotification(context, null, response.body, ContentType.failure, 5);
          }).catchError((error, stackTrace) {
            ProgressHud.of(context)?.dismiss();
            Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
