import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/mt_systems.dart' as System;
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

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
  late Future<ProjectModels> _listOfDefectAnalysis;
  late Future<SystemModels> _listOfSystems;
  late bool idSystemIsEnable;

  Future<ProjectModels> _getListProjects() async {
    var sortOptions = [];
    var filterOptions = [];
    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await Common.getListProjects(options);

    if (response.statusCode == 200) {
      var result = ProjectModels.fromJson(jsonDecode(response.body));
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<SystemModels> _getListSystems(int id) async {
    var sortOptions = [];
    var filterOptions = [];
    var options = new LoadOptionsModel(
      take: 0,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    var response = await System.getListByProject(id, options);
    switch (response.statusCode) {
      case 200:
        return SystemModels.fromJson(jsonDecode(response.body));
      case 401:
        throw response.statusCode;
      default:
        throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _listOfDefectAnalysis = _getListProjects();
    _listOfSystems = _getListSystems(0);
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
        child: FormBuilder(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.always,
          //skipDisabled: true,
          initialValue: {
            'idProject': null,
            'idSystem': null,
            'code': null,
            'analysisDate': null,
            'analysisBy': null,
            'currentSuitation': null,
            'maintenanceStaff': null,
            'qcStaff': null,
            'cncStaff': null,
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                idProjectForm(),
                idSystemForm(),
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
        ),
      ),
    );
  }

  Widget idProjectForm() {
    return FutureBuilder(
      future: _listOfDefectAnalysis,
      builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else {
          if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
            return LoadingWidget();
          else {
            if (snapshot.hasData) {
              return FormBuilderDropdown<String>(
                name: 'idProject',
                decoration: InputDecoration(
                  labelText: 'Dự án triển khai',
                  labelStyle: TextStyle(fontSize: 18),
                ),
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
                  print(val);
                  setState(() {
                    idSystemIsEnable = true;
                    _listOfSystems = _getListSystems(int.parse(val));
                  });
                  print(idSystemIsEnable);
                },
                valueTransformer: (val) => val?.toString(),
              );
            } else
              return LoadingWidget();
          }
        }
      },
    );
  }

  Widget idSystemForm() {
    return FutureBuilder(
      future: _listOfSystems,
      builder: (BuildContext context, AsyncSnapshot<SystemModels> snapshot) {
        if (snapshot.hasError)
          return DataErrorWidget(error: snapshot.error.toString());
        else {
          if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
            return LoadingWidget();
          else {
            if (snapshot.hasData) {
              return FormBuilderDropdown<String>(
                name: 'idSystem',
                enabled: idSystemIsEnable,
                decoration: InputDecoration(
                  labelText: 'Hệ thống cần phân tích',
                  labelStyle: TextStyle(fontSize: 18),
                ),
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
            } else
              return LoadingWidget();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Create2 extends StatelessWidget {
  Future<ProjectModels> _getListProjectForCreate() async {
    var sortOptions = [
      // {"selector": "nhomDanhMuc", "desc": "false"},
      // {"selector": "sapXep", "desc": "false"}
    ];
    var filterOptions = [];
    var options = new LoadOptionsModel(
      take: 0,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    var response = await Common.getListProjects(options);

    if (response.statusCode == 200) {
      var result = ProjectModels.fromJson(jsonDecode(response.body));
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Future<ProjectModels> listProject = _getListProjectForCreate();
    return Scrollbar(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "LỰA CHỌN DỰ ÁN - KHÁCH HÀNG",
                style: TextStyle(color: kPrimaryColor, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<ProjectModels>(
              future: listProject,
              builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
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
                          groupBy: (element) => element.customer,
                          groupSeparatorBuilder: (String value) => Container(
                            width: MediaQuery.of(context).size.width,
                            color: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    value.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    "Khách hàng",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemBuilder: (context, dynamic element) => ListTile(
                            title: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: element.name.toString(),
                                style: TextStyle(fontSize: 16.0, color: kPrimaryColor, fontWeight: FontWeight.bold),
                              ),
                            ])),
                            subtitle: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Mã hiệu : ${element.code}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                              ),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "|"),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(
                                text: "Địa điểm: ${element.location}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                              )
                            ])),
                            trailing: Icon(Ionicons.arrow_redo_outline, color: kSecondaryColor, size: 18.0),
                            //onTap: () => Navigator.pushNamed(context, CreateDeXuatScreen.routeName, arguments: {'danhmuc': element}),
                          ), // optional
                          separator: const Divider(color: kPrimaryColor),
                          floatingHeader: true, useStickyGroupSeparators: true,
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
}
