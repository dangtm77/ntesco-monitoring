import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/string.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/UserModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/defect_analysis_screen.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

class DefectAnalysisCreateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis/create";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: CreateBody());
  }
}

class CreateBody extends StatefulWidget {
  CreateBody({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => new _CreatePageState();
}

class _CreatePageState extends State<CreateBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<ProjectModels> _listOfProjects;
  late Future<SystemModels> _listOfSystems;
  late Future<UserModels> _listOfUsers;
  late bool idSystemIsEnable;

  Future<ProjectModels> _getListProjects() async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Common.Projects_GetList(options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return ProjectModels.fromJson(jsonDecode(response.body));
      else
        throw Exception('StatusCode: ${response.statusCode}');
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
        throw Exception('StatusCode: ${response.statusCode}');
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
      else {
        print(response.body);
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (ex) {
      throw ex;
    }
  }

  @override
  void initState() {
    super.initState();
    _listOfProjects = _getListProjects();
    _listOfSystems = _getListSystems(0);
    _listOfUsers = _getListUsers();
    idSystemIsEnable = false;
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
          title: "maintenance.defect_analysis.create_title".tr(),
          subtitle: "maintenance.defect_analysis.create_subtitle",
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
                    'idProject': null,
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
                              press: () async => submitFunc(context),
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
      case "idProject":
        return FutureBuilder(
          future: _listOfProjects,
          builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
              return CircularProgressIndicator();
            else
              return FormBuilderDropdown<String>(
                name: 'idProject',
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
                        value: item.id.toString(),
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
                onChanged: (dynamic val) {
                  if (val != null)
                    setState(() {
                      idSystemIsEnable = true;
                      _listOfSystems = _getListSystems(int.parse(val));
                    });
                },
                valueTransformer: (val) => val?.toString(),
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              );
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
              return FormBuilderDropdown<String>(
                name: 'idSystem',
                enabled: idSystemIsEnable,
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
                        value: item.id.toString(),
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
                valueTransformer: (val) => val?.toString(),
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
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 49)
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
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 28)
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
                    .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 41)
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
            if (response.statusCode >= 200 && response.statusCode <= 299) {
              ProgressHud.of(context)?.showSuccessAndDismiss(text: "Thành công");
              Navigator.pushReplacementNamed(context, DefectAnalysisScreen.routeName);
            } else {
              ProgressHud.of(context)?.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  content: Text("Có lỗi xảy ra"),
                ),
              );
            }
          }).catchError((error, stackTrace) {
            ProgressHud.of(context)?.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                content: Text("Có lỗi xảy ra. Chi tiết: $error"),
              ),
            );
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
