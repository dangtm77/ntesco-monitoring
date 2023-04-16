// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/photoview_gallery.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/UserModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisDetailsModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/details/create.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:ntesco_smart_monitoring/theme.dart';

import '../../defect_analysis_screen.dart';
import 'details/update.dart';

class DefectAnalysisUpdateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis/update";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = int.parse(arguments['id'].toString());
    int tabIndex = int.parse(arguments['tabIndex'].toString());
    return Scaffold(drawerScrimColor: Colors.transparent, body: UpdateBody(id: id, tabIndex: tabIndex));
  }
}

class UpdateBody extends StatefulWidget {
  final int id;
  final int tabIndex;
  UpdateBody({Key? key, required this.id, required this.tabIndex}) : super(key: key);

  @override
  _UpdateBodyState createState() => new _UpdateBodyState(id, tabIndex);
}

class _UpdateBodyState extends State<UpdateBody> {
  final int id;
  final int tabIndex;
  _UpdateBodyState(this.id, this.tabIndex);

  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late int _currentIndex = tabIndex;
  late PageController _pageController;
  late Future<DefectAnalysisModel> _defectAnalysis;

  @override
  void initState() {
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
    super.initState();
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _currentIndex = tabIndex;
        _pageController = PageController(initialPage: tabIndex);
        _defectAnalysis = _getDetailOfDefectAnalysis();
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<DefectAnalysisModel> _getDetailOfDefectAnalysis() async {
    var options = new Map<String, dynamic>();
    options.addAll({"id": id.toString()});
    Response response = await Maintenance.DefectAnalysis_GetDetail(options);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      DefectAnalysisModel result = DefectAnalysisModel.fromJson(jsonDecode(response.body));
      return result;
    } else
      throw Exception(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_header(), _main(context)],
        ),
      ),
    );
  }

  Widget _header() => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis.update_title".tr(),
          subtitle: "maintenance.defect_analysis.update_subtitle".tr(),
          buttonLeft: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pushNamed(context, DefectAnalysisScreen.routeName),
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
        ),
      );

  Widget _main(BuildContext context) => Expanded(
        child: (isOnline)
            ? FutureBuilder<DefectAnalysisModel>(
                future: _defectAnalysis,
                builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModel> snapshot) {
                  if (snapshot.hasError) {
                    return DataErrorWidget(error: snapshot.error.toString());
                  } else {
                    if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                      return LoadingWidget();
                    else {
                      if (snapshot.hasData && snapshot.data != null) {
                        var item = snapshot.data!;
                        return Scaffold(
                          body: SizedBox.expand(
                            child: PageView(
                              controller: _pageController,
                              //physics: NeverScrollableScrollPhysics(),
                              onPageChanged: ((value) => setState(() => _currentIndex = value)),
                              children: <Widget>[
                                SummaryPageView(id: item.id, model: item),
                                DetailsPageView(id: item.id, model: item),
                                CommentsPageView(id: item.id, model: item),
                              ],
                            ),
                          ),
                          bottomNavigationBar: BottomNavyBar(
                            iconSize: 30,
                            showElevation: true,
                            itemCornerRadius: 20.0,
                            containerHeight: 70.0,
                            selectedIndex: _currentIndex,
                            onItemSelected: (value) {
                              setState(() => _currentIndex = value);
                              _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
                            },
                            items: <BottomNavyBarItem>[
                              BottomNavyBarItem(
                                icon: Icon(Ionicons.reader_outline),
                                textAlign: TextAlign.center,
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Thông tin', style: TextStyle(fontSize: 15)),
                                      Text('CHUNG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              BottomNavyBarItem(
                                icon: Icon(Ionicons.git_branch_outline),
                                textAlign: TextAlign.center,
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Chi tiết', style: TextStyle(fontSize: 15)),
                                      Text('SỰ CỐ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              BottomNavyBarItem(
                                icon: Icon(Icons.comment_outlined),
                                textAlign: TextAlign.center,
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Ý kiến', style: TextStyle(fontSize: 15)),
                                      Text('PHẢN HỒI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return NoDataWidget(message: "Không tìm thấy thông tin phiếu đề xuất!!!");
                      }
                    }
                  }
                },
              )
            : NoConnectionWidget(),
      );
}

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
                        Expanded(flex: 2, child: DefaultButton(text: 'Hủy bỏ thông tin', color: Colors.red, press: () async => deleteFunc(context, model))),
                        SizedBox(width: 10),
                        Expanded(flex: 3, child: DefaultButton(text: 'Cập nhật thông tin', color: kPrimaryColor, press: () async => submitFunc(context))),
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

class DetailsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;

  const DetailsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  _DetailsPageViewState createState() => new _DetailsPageViewState(id, model);
}

class _DetailsPageViewState extends State<DetailsPageView> {
  final int id;
  final DefectAnalysisModel model;
  _DetailsPageViewState(this.id, this.model);

  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;

  late Future<DefectAnalysisDetailsModels> _listOfDefectAnalysisDetails;

  Future<DefectAnalysisDetailsModels> _getListDefectAnalysisDetails() async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Maintenance.DefectAnalysisDetails_GetList(model.id, options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        DefectAnalysisDetailsModels result = DefectAnalysisDetailsModels.fromJson(jsonDecode(response.body));
        setState(() {
          isLoading = false;
        });
        return result;
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  @override
  void initState() {
    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
                    isLoading = true;
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
                  });
                },
                child: FutureBuilder<DefectAnalysisDetailsModels>(
                  future: _listOfDefectAnalysisDetails,
                  builder: (BuildContext context, AsyncSnapshot<DefectAnalysisDetailsModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget(message: "Không tìm thấy dữ liệu");

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                        child: ListView.separated(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = snapshot.data!.data.elementAt(index);
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(child: FadeInAnimation(child: _item(item))),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(color: kPrimaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(10.0),
              horizontal: getProportionateScreenWidth(10.0),
            ),
            child: Center(
              child: DefaultButton(
                text: 'THÊM THÔNG TIN SỰ CỐ',
                press: () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => DefectAnalysisDetailsCreateScreen(id: id),
                ).then((value) {
                  setState(() {
                    isLoading = false;
                    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
                  });
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(DefectAnalysisDetailsModel item) {
    List<String> imagesList = (item.pictures != null && item.pictures!.length > 0) ? item.pictures!.map((e) => Common.System_DowloadFile_ByID(e.id, 'view')).toList() : [urlNoImage];

    return ListTile(
      onTap: () => showCupertinoModalBottomSheet(
        context: context,
        builder: (_) => Material(
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  trailing: Icon(Ionicons.arrow_forward, color: kPrimaryColor),
                  title: Row(
                    children: [
                      Icon(Ionicons.create_outline, color: kPrimaryColor),
                      SizedBox(width: 10.0),
                      Text('Xem / Cập nhật / chỉnh sửa thông tin', style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, DefectAnalysisDetailsUpdateScreen.routeName, arguments: {'id': item.id, 'idDefectAnalysis': item.idDefectAnalysis, 'tabIndex': 0});
                  },
                ),
                ListTile(
                  trailing: Icon(Ionicons.arrow_forward, color: kPrimaryColor),
                  title: Row(
                    children: [
                      Icon(Ionicons.trash_bin_outline, color: kPrimaryColor),
                      SizedBox(width: 10.0),
                      Text('Xóa / Hủy bỏ thông tin', style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                    ],
                  ),
                  onTap: () => deleteFunc(item.id),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: Badge(
        showBadge: imagesList.length > 1,
        badgeContent: Text('${imagesList.length}', style: TextStyle(fontSize: 15, color: Colors.white)),
        badgeAnimation: BadgeAnimation.scale(),
        badgeStyle: BadgeStyle(badgeColor: kPrimaryColor),
        child: CachedNetworkImage(
          imageUrl: imagesList.first,
          imageBuilder: (context, imageProvider) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewGalleryScreen(imageUrls: imagesList, initialIndex: 0))),
            child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
          placeholder: (context, url) => SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item.partName}", style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
          SizedBox(height: 5.0),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
              children: [
                TextSpan(
                  children: [
                    TextSpan(text: "Số lượng: ", style: TextStyle(color: kTextColor)),
                    TextSpan(text: "${item.partQuantity}", style: TextStyle(color: kPrimaryColor)),
                  ],
                ),
                (item.partManufacturer != null && item.partManufacturer!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "NSX: ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.partManufacturer}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
                (item.partModel != null && item.partModel!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "Model: ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.partModel}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
              ],
            ),
          ),
          Visibility(
              visible: (item.partSpecifications != null && item.partSpecifications!.length > 0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                          children: [
                            TextSpan(text: "Thông số kỹ thuật: ", style: TextStyle(color: kTextColor)),
                            TextSpan(text: "${item.partSpecifications}", style: TextStyle(color: kPrimaryColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> deleteFunc(key) async {
    Navigator.of(context).pop();
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
        await Maintenance.DefectAnalysisDetails_Delete(key).then((response) {
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, 'Xóa bỏ thành công', response.body, ContentType.success, 3);
            setState(() {
              isLoading = false;
              _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
            });
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

class CommentsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;
  const CommentsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<CommentsPageView> createState() => _CommentsPageViewState(id, model);
}

class _CommentsPageViewState extends State<CommentsPageView> {
  final int id;
  final DefectAnalysisModel model;
  _CommentsPageViewState(this.id, this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("ĐANG CẬP NHẬT ...")),
    );
  }
}
