import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:awesome_select/awesome_select.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as common;
import 'package:ntesco_smart_monitoring/core/mt_defect_analysis.dart' as MT;
import 'package:ntesco_smart_monitoring/helper/network.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/VariableModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late List<int> _projectsCurrent = [];
  late List<int> _statusCurrent = [];
  late Future<DefectAnalysisModels> _listOfDefectAnalysis;

  @override
  void initState() {
    NetworkHelper.instance.initialise();
    NetworkHelper.instance.myStream.listen((rs) {
      var result = rs.keys.toList()[0];
      setState(() {
        isOnline = (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) ? true : false;
      });
      setState(() {});
    });

    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<DefectAnalysisModels> _getlistOfDefectAnalysis() async {
    var sortOptions = [
      // {"selector": "startDate", "desc": "true"},
      // {"selector": "endDate", "desc": "true"}
    ];
    var filterOptions = [];
    //FILTER BY PROJECT
    if (_projectsCurrent.isNotEmpty && _projectsCurrent.length > 0) {
      var projectsFilterOptions = [];
      _projectsCurrent.forEach((id) {
        projectsFilterOptions.add(['systems.idProject', '=', id]);
        projectsFilterOptions.add("or");
      });
      if (projectsFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        if (projectsFilterOptions.last == "or") projectsFilterOptions.removeAt(projectsFilterOptions.length - 1);
        if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
      }
    }

    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await MT.getList(options);
    if (response.statusCode == 200) {
      var result = DefectAnalysisModels.fromJson(jsonDecode(response.body));
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<List<S2Choice<int>>> _getListProjectsForSelect() async {
    var sortOptions = [];
    var filterOptions = [];
    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await common.getListProjects(options);
    if (response.statusCode == 200) {
      var result = ProjectModels.fromJson(jsonDecode(response.body));

      return S2Choice.listFrom<int, dynamic>(
        source: result.data,
        value: (index, item) => item.id,
        title: (index, item) => item.name,
      );
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<List<S2Choice<int>>> _getListVarialForSelect() async {
    var sortOptions = [];
    var filterOptions = [
      ['group', '=', 'MAINTENANCE_DEFECT_ANALYSIS_STATUS']
    ];
    var options = new LoadOptionsModel(
      take: 0,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    var response = await common.getListVariables(options);
    print(response.body);
    if (response.statusCode == 200) {
      var result = VariableModels.fromJson(jsonDecode(response.body));
      print(result.totalCount);
      return S2Choice.listFrom<int, dynamic>(
        source: result.data,
        value: (index, item) => item.value,
        title: (index, item) => item.text,
      );
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _header(context),
            _listAll(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return TopHeaderSub(
      title: "maintenance.defect_analysis_title".tr(),
      subtitle: "maintenance.defect_analysis_subtitle".tr(),
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
        onTap: () => showModalBottomSheet(builder: (BuildContext context) => _filter(context), context: context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Ionicons.filter_outline,
              color: (_projectsCurrent.length > 0) ? kPrimaryColor : Colors.grey.shade500,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filter(BuildContext context) {
    Future<List<S2Choice<int>>> projectFilter = _getListProjectsForSelect();
    Future<List<S2Choice<int>>> statusFilter = _getListVarialForSelect();

    return Scrollbar(
      child: ListView(
        addAutomaticKeepAlives: true,
        children: [
          FutureBuilder<List<S2Choice<int>>>(
            initialData: [],
            future: projectFilter,
            builder: (context, snapshot) {
              return SmartSelect<int>.multiple(
                title: 'Xem theo dự án',
                placeholder: "Vui lòng chọn ít nhất 1 dự án",
                modalFilter: true,
                selectedValue: _projectsCurrent,
                choiceItems: snapshot.data,
                modalHeader: true,
                choiceType: S2ChoiceType.checkboxes,
                modalType: S2ModalType.fullPage,
                onChange: (state) => setState(() => _projectsCurrent = state.value),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    trailing: state.selected.length > 0
                        ? CircleAvatar(
                            radius: 15,
                            backgroundColor: kPrimaryColor,
                            child: Text(
                              '${state.selected.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                  );
                },
              );
            },
          ),
          FutureBuilder<List<S2Choice<int>>>(
            initialData: [],
            future: statusFilter,
            builder: (context, snapshot) {
              return SmartSelect<int>.multiple(
                title: 'Xem theo trạng thái',
                placeholder: "Vui lòng chọn ít nhất 1 trạng thái",
                modalFilter: true,
                selectedValue: _statusCurrent,
                choiceItems: snapshot.data,
                modalHeader: true,
                choiceType: S2ChoiceType.checkboxes,
                modalType: S2ModalType.fullPage,
                onChange: (state) => setState(() => _statusCurrent = state.value),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    trailing: state.selected.length > 0
                        ? CircleAvatar(
                            radius: 15,
                            backgroundColor: kPrimaryColor,
                            child: Text(
                              '${state.selected.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                  );
                },
              );
            },
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DefaultButton(
                text: "Xác nhận",
                press: () {
                  setState(() {
                    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listAll(BuildContext context) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        child: (isOnline)
            ? RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                  });
                },
                child: FutureBuilder<DefectAnalysisModels>(
                  future: _listOfDefectAnalysis,
                  builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModels> snapshot) {
                    if (snapshot.hasError)
                      return DataErrorWidget(error: snapshot.error.toString());
                    else {
                      if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active))
                        return LoadingWidget();
                      else {
                        if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
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
                                    child: SlideAnimation(
                                      child: FadeInAnimation(child: _item(item)),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              ),
                            ),
                          );
                        } else
                          return NoDataWidget(message: "Không tìm thấy phiếu đề xuất nào liên quan đến bạn !!!");
                      }
                    }
                  },
                ),
              )
            : NoConnectionWidget(),
      ),
    );
  }

  Widget _item(DefectAnalysisModel item) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(
            style: TextStyle(fontSize: getProportionateScreenWidth(11), fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            children: [
              TextSpan(text: "Dự án: ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.system.project.name?.toUpperCase()}", style: TextStyle(color: kPrimaryColor)),
            ],
          )),
          SizedBox(height: 5.0),
          Text.rich(TextSpan(
            style: TextStyle(fontSize: getProportionateScreenWidth(11), fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            children: [
              TextSpan(text: "Hệ thống: ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.system.name?.toUpperCase()}", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 10.0)),
              TextSpan(text: "Mã hiệu: ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.code}", style: TextStyle(color: kPrimaryColor)),
            ],
          )),
          SizedBox(height: 5.0),
          Text.rich(TextSpan(
            style: TextStyle(fontSize: getProportionateScreenWidth(11), fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            children: [
              WidgetSpan(child: Icon(Icons.label_important_rounded, size: getProportionateScreenWidth(12), color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.statusInfo.text}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.person_add_alt_1, size: getProportionateScreenWidth(12), color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.analysisByInfo!.hoTen}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.calendar_month, size: getProportionateScreenWidth(12), color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.analysisDate}", style: TextStyle(color: kTextColor)),
            ],
          )),
        ],
      ),
    );
  }
}
