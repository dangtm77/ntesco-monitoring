import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/mt_defect_analysis.dart' as MT;
import 'package:ntesco_smart_monitoring/helper/network.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/VariableModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/create.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;

  TextEditingController _keywordForSearchEditingController = TextEditingController();

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

    _keywordForSearchEditingController.text = "";
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
        projectsFilterOptions.add(['system.idProject', '=', id]);
        projectsFilterOptions.add("or");
      });
      if (projectsFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        if (projectsFilterOptions.last == "or") projectsFilterOptions.removeAt(projectsFilterOptions.length - 1);
        if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
      }
    }
    //FILTER BY STATUS
    if (_statusCurrent.isNotEmpty && _statusCurrent.length > 0) {
      var statusFilterOptions = [];
      _statusCurrent.forEach((id) {
        statusFilterOptions.add(['status', '=', id]);
        statusFilterOptions.add("or");
      });
      if (statusFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        if (statusFilterOptions.last == "or") statusFilterOptions.removeAt(statusFilterOptions.length - 1);
        if (statusFilterOptions.length > 0) filterOptions.add(statusFilterOptions);
      }
    }

    //FILTER BY KEYWORD
    if (_keywordForSearchEditingController.text.isNotEmpty && _keywordForSearchEditingController.text.length > 3) {
      var searchGroupFilterOptions = [];
      if (filterOptions.length > 0) filterOptions.add('and');
      searchGroupFilterOptions.add(['code', 'contains', _keywordForSearchEditingController.text.toString()]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.name', 'contains', _keywordForSearchEditingController.text.toString()]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.code', 'contains', _keywordForSearchEditingController.text.toString()]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.project.code', 'contains', _keywordForSearchEditingController.text.toString()]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.project.contractNo', 'contains', _keywordForSearchEditingController.text.toString()]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.project.name', 'contains', _keywordForSearchEditingController.text.toString()]);
      filterOptions.add(searchGroupFilterOptions);
    }
    print(jsonEncode(filterOptions));

    var options = new LoadOptionsModel(
      take: itemPerPage * pageIndex,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    var response = await MT.getList(options);

    print(response.body);
    if (response.statusCode == 200) {
      var result = DefectAnalysisModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
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
    var response = await Common.getListProjects(options);
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
    var response = await Common.getListVariables(options);
    if (response.statusCode == 200) {
      var result = VariableModels.fromJson(jsonDecode(response.body));
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
            isOnline ? _searchBar(context) : SizedBox.shrink(),
            _listAll(context),
            Container(
              height: isLoading ? 30.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [Text("Đang tải thêm $itemPerPage dòng dữ liệu...", style: TextStyle(fontSize: 15))],
                ),
              ),
            ),
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
        onTap: () => Navigator.pushNamed(context, MaintenanceDefectAnalysisCreateScreen.routeName),
        child: Icon(
          Icons.addchart_outlined,
          color: kPrimaryColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
        child: TextField(
          controller: _keywordForSearchEditingController,
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty && value.trim().length > 3) {
                isLoading = false;
                _listOfDefectAnalysis = _getlistOfDefectAnalysis();
              }
            });
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.all(0.0),
              prefixIcon: Icon(Ionicons.search, size: 20, color: Colors.grey.shade600),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_keywordForSearchEditingController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _keywordForSearchEditingController.clear();
                            isLoading = false;
                            _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                          });
                        },
                        icon: Icon(Ionicons.close_circle, color: Colors.grey.shade500, size: 20),
                      ),
                    IconButton(
                      onPressed: () => showModalBottomSheet(builder: (BuildContext context) => _filter(context), context: context),
                      icon: Icon(
                        Ionicons.filter,
                        color: (_statusCurrent.length > 0 || _projectsCurrent.length > 0) ? kPrimaryColor : Colors.grey.shade500,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              hintText: "Nhập từ khóa để tìm kiếm..."),
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
                modalType: S2ModalType.popupDialog,
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
                modalType: S2ModalType.popupDialog,
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
                text: "Xác nhận thông tin",
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
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() {
              pageIndex = pageIndex + 1;
              _listOfDefectAnalysis = _getlistOfDefectAnalysis();
              isLoading = true;
            });
          }
          return true;
        },
        child: (isOnline)
            ? RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                  });
                },
                child: FutureBuilder<DefectAnalysisModels>(
                  future: _listOfDefectAnalysis,
                  builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModels> snapshot) {
                    if (snapshot.hasError)
                      return DataErrorWidget(error: snapshot.error.toString());
                    else {
                      if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading)
                        return LoadingWidget();
                      else {
                        if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(10.0),
                              horizontal: getProportionateScreenWidth(0.0),
                            ),
                            child: AnimationLimiter(
                                child: GroupedListView<dynamic, String>(
                              elements: snapshot.data!.data,
                              groupBy: (element) => "${element.system.project.name} (${element.system.project.customer})",
                              groupSeparatorBuilder: (String value) => Container(
                                width: MediaQuery.of(context).size.width,
                                color: kPrimaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                              itemBuilder: (BuildContext context, dynamic item) {
                                return AnimationConfiguration.staggeredList(
                                  position: 0,
                                  duration: const Duration(milliseconds: 400),
                                  child: SlideAnimation(
                                    child: FadeInAnimation(child: _item(item)),
                                  ),
                                );
                              },
                              separator: Divider(thickness: 1, endIndent: getProportionateScreenHeight(15.0), indent: getProportionateScreenHeight(15.0), color: kPrimaryColor),
                              floatingHeader: false,
                              useStickyGroupSeparators: true,
                            )),
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            children: [
              TextSpan(text: "Mã hiệu: ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.code}", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "Hệ thống: ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.system.name}", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "Có ", style: TextStyle(color: kTextColor)),
              TextSpan(text: "${item.totalDetail} sự cố", style: TextStyle(color: kPrimaryColor)),
            ],
          )),
          SizedBox(height: 5.0),
          Text.rich(TextSpan(
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            children: [
              WidgetSpan(child: Icon(Icons.label_important_rounded, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.statusInfo.text}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.person_add_alt_1, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.analysisByInfo!.hoTen}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.calendar_month, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.analysisDate}", style: TextStyle(color: kTextColor)),
            ],
          )),
        ],
      ),
    );
  }
}
