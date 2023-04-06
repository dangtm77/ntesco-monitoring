import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ntesco_smart_monitoring/models/common/UserModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

class MaintenanceDefectAnalysisCreateScreen extends StatelessWidget {
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
      Response response = await Common.Projects_GetList(options);
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
      Response response = await Maintenance.Systems_GetList_ByProject(id, options);
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
      Response response = await Common.Users_GetList(options);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_header(), _form(context)],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
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
  }

  Widget _form(BuildContext context) {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                initialValue: {
                  'idProject': null,
                  'idSystem': null,
                  'code': null,
                  'analysisDate': DateTime.now(),
                  'analysisBy': null,
                  'currentSuitation': null,
                  'maintenanceStaff': null,
                  'qcStaff': null,
                  'cncStaff': null,
                },
                child: Column(
                  children: <Widget>[
                    idProjectForm(),
                    SizedBox(height: 20),
                    idSystemForm(),
                    SizedBox(height: 20),
                    codeForm(),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        analysisByForm(),
                        const SizedBox(width: 15),
                        analysisDateForm(),
                      ],
                    ),
                    SizedBox(height: 20),
                    currentSuitationForm(),
                    SizedBox(height: 20),
                    maintenanceStaffForm(),
                    SizedBox(height: 20),
                    qcStaffForm(),
                    SizedBox(height: 20),
                    cncStaffForm(),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              if (_formKey.currentState?.saveAndValidate() ?? false) {
                                debugPrint(_formKey.currentState?.value.toString());
                              } else {
                                debugPrint(_formKey.currentState?.value.toString());
                                debugPrint('validation failed');
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                            // color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
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
  }

  Widget idProjectForm() {
    return FutureBuilder(
      future: _listOfProjects,
      builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
          return LoadingWidget();
        else
          return FormBuilderDropdown<String>(
            name: 'idProject',
            decoration: InputDecoration(
              labelText: 'Dự án triển khai',
              hintText: "Vui lòng chọn...",
            ).applyDefaults(inputDecorationTheme()),
            menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
            items: snapshot.data!.data
                .map((item) => DropdownMenuItem(
                      alignment: AlignmentDirectional.topStart,
                      value: item.id.toString(),
                      child: Text("${item.name} (${item.location})"),
                    ))
                .toList(),
            onChanged: (dynamic val) {
              if (val != null)
                setState(() {
                  idSystemIsEnable = true;
                  _listOfSystems = _getListSystems(int.parse(val));
                });
            },
            valueTransformer: (val) => val?.toString(),
          );
      },
    );
  }

  Widget idSystemForm() {
    return FutureBuilder(
      future: _listOfSystems,
      builder: (BuildContext context, AsyncSnapshot<SystemModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
          return LoadingWidget();
        else
          return FormBuilderDropdown<String>(
            name: 'idSystem',
            enabled: idSystemIsEnable,
            decoration: InputDecoration(
              labelText: 'Hệ thống cần phân tích',
              hintText: "Vui lòng chọn...",
            ).applyDefaults(inputDecorationTheme()),
            menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
            items: snapshot.data!.data
                .map((item) => DropdownMenuItem(
                      alignment: AlignmentDirectional.topStart,
                      value: item.name.toString(),
                      child: Text("${item.name} - (${DateFormat("dd/MM/yyyy").format(item.dateAcceptance!)})"),
                    ))
                .toList(),
            valueTransformer: (val) => val?.toString(),
          );
      },
    );
  }

  Widget codeForm() {
    return FormBuilderTextField(
      name: "code",
      decoration: const InputDecoration(
        labelText: 'Mã hiệu',
        hintText: "Vui lòng chọn...",
      ).applyDefaults(inputDecorationTheme()),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
    );
  }

  Widget analysisDateForm() {
    return Expanded(
      child: FormBuilderDateTimePicker(
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
      ),
    );
  }

  Widget analysisByForm() {
    return Expanded(
      child: FutureBuilder(
        future: _listOfUsers,
        builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
          if (snapshot.hasError)
            return DataErrorWidget(error: snapshot.error.toString());
          else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
            return LoadingWidget();
          else
            return FormBuilderDropdown<String>(
              name: 'analysisByForm',
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
                      child: Text("${item.hoTen} (${item.chucDanh})"),
                    ),
                  )
                  .toList(),
              valueTransformer: (val) => val?.toString(),
            );
        },
      ),
    );
  }

  Widget currentSuitationForm() {
    return FormBuilderTextField(
      name: "currentSuitation",
      decoration: const InputDecoration(
        labelText: 'Hiện trạng',
        hintText: "Vui lòng nhập thông tin...",
      ).applyDefaults(inputDecorationTheme()),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
    );
  }

  Widget maintenanceStaffForm() {
    return FutureBuilder(
      future: _listOfUsers,
      builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
          return LoadingWidget();
        else
          return FormBuilderDropdown<String>(
            name: 'maintenanceStaff',
            menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
            decoration: InputDecoration(
                labelText: 'Đại diện bộ phận Bảo trì',
                hintText: "Vui lòng chọn thông tin...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _formKey.currentState!.fields['maintenanceStaff']?.didChange(null),
                )).applyDefaults(inputDecorationTheme()),
            items: snapshot.data!.data
                .where((x) => x.idTrangThai != 3 && x.idRootPhongBan == 49)
                .map(
                  (item) => DropdownMenuItem(
                    value: item.username.toString(),
                    child: Text("${item.hoTen} (${item.chucDanh})"),
                  ),
                )
                .toList(),
            valueTransformer: (val) => val?.toString(),
          );
      },
    );
  }

  Widget qcStaffForm() {
    return FutureBuilder(
      future: _listOfUsers,
      builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
          return LoadingWidget();
        else
          return FormBuilderDropdown<String>(
            name: 'qcStaff',
            menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
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
                    child: Text("${item.hoTen} (${item.chucDanh})"),
                  ),
                )
                .toList(),
            valueTransformer: (val) => val?.toString(),
          );
      },
    );
  }

  Widget cncStaffForm() {
    return FutureBuilder(
      future: _listOfUsers,
      builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
          return LoadingWidget();
        else
          return FormBuilderDropdown<String>(
            name: 'cncStaff',
            menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
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
                    child: Text("${item.hoTen} (${item.chucDanh})"),
                  ),
                )
                .toList(),
            valueTransformer: (val) => val?.toString(),
          );
      },
    );
  }

/*
  Widget _selectUserInfo(BuildContext context, String key) {
    return Scrollbar(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Vui lòng chọn thông tin cần thiết...",
                style: TextStyle(color: kPrimaryColor, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<UserModels>(
              future: _listOfUsers,
              builder: (BuildContext context, AsyncSnapshot<UserModels> snapshot) {
                if (snapshot.hasError)
                  return DataErrorWidget(error: snapshot.error.toString());
                else {
                  if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                    return LoadingWidget();
                  else {
                    if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                      return AnimationLimiter(
                        child: GroupedListView<dynamic, String>(
                          elements: snapshot.data!.data,
                          groupBy: (element) => ((element.idRootPhongBan == element.idPhongBan) ? "Phòng " : "Bộ phận ") + element.phongBan,
                          groupSeparatorBuilder: (String value) => Container(
                            width: MediaQuery.of(context).size.width,
                            color: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "$value".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (context, dynamic element) => ListTile(
                            leading: CircleAvatar(radius: 18.0, backgroundImage: NetworkImage(element.anhDaiDien.toString())),
                            title: Text(
                              element.hoTen.toString(),
                              style: const TextStyle(fontSize: 15.0, color: kPrimaryColor, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${element.chucDanh ?? "Chưa xác định"}",
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            trailing: Icon(Ionicons.arrow_redo_outline, color: kSecondaryColor, size: 18.0),
                            onTap: () {
                              Navigator.pop(context);
                              _formKey.currentState!.fields[key]!.didChange(element.username);
                            },
                          ),
                          order: GroupedListOrder.DESC,
                          floatingHeader: true,
                          useStickyGroupSeparators: true,
                        ),
                      );
                    } else
                      return NoDataWidget(message: "Không tìm thấy phiếu đề xuất liên quan nào !!!");
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
*/

  @override
  void dispose() {
    super.dispose();
  }
}
