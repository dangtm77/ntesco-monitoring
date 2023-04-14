import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:ntesco_smart_monitoring/models/common/VariableModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/create.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;

  TextEditingController _keywordForSearchEditingController = TextEditingController();

  late List<int> _projectsCurrent = [];
  late List<int> _statusCurrent = [];
  late Future<DefectAnalysisModels> _listOfDefectAnalysis;

  @override
  void initState() {
    _keywordForSearchEditingController.text = "";
    super.initState();
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _listOfDefectAnalysis = _getlistOfDefectAnalysis();
      });
    });
  }

  Future<DefectAnalysisModels> _getlistOfDefectAnalysis() async {
    List<dynamic> sortOptions = [
      {"selector": "totalDetail", "desc": "true"},
      {"selector": "analysisDate", "desc": "true"},
      {"selector": "dateCreate", "desc": "true"}
    ];
    List<dynamic> filterOptions = [];
    //FILTER BY PROJECT
    if (_projectsCurrent.isNotEmpty && _projectsCurrent.length > 0) {
      List<dynamic> projectsFilterOptions = [];
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
      List<dynamic> statusFilterOptions = [];
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
    if (_keywordForSearchEditingController.text.isNotEmpty && _keywordForSearchEditingController.text.trim().length > 3) {
      List<dynamic> searchGroupFilterOptions = [];
      String _keyword = _keywordForSearchEditingController.text.trim().toString();
      if (filterOptions.length > 0) filterOptions.add('and');
      searchGroupFilterOptions.add(['code', 'contains', _keyword]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.name', 'contains', _keyword]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['system.code', 'contains', _keyword]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['project.code', 'contains', _keyword]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['project.contractNo', 'contains', _keyword]);
      searchGroupFilterOptions.add('or');
      searchGroupFilterOptions.add(['project.name', 'contains', _keyword]);
      filterOptions.add(searchGroupFilterOptions);
    }

    print(jsonEncode(sortOptions));
    print(jsonEncode(filterOptions));

    LoadOptionsModel options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.DefectAnalysis_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      DefectAnalysisModels result = DefectAnalysisModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
      return result;
    } else {
      throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  Future<List<S2Choice<int>>> _getListProjectsForSelect() async {
    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [];
    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Common.Projects_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      ProjectModels result = ProjectModels.fromJson(jsonDecode(response.body));
      return S2Choice.listFrom<int, dynamic>(
        source: result.data,
        value: (index, item) => item.id,
        title: (index, item) => item.name,
      );
    } else {
      throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  Future<List<S2Choice<int>>> _getListVarialForSelect() async {
    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [
      ['group', '=', 'MAINTENANCE_DEFECT_ANALYSIS_STATUS']
    ];
    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Common.Variables_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      VariableModels result = VariableModels.fromJson(jsonDecode(response.body));
      return S2Choice.listFrom<int, dynamic>(
        source: result.data,
        value: (index, item) => item.value,
        title: (index, item) => item.text,
      );
    } else {
      throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(width: 10.0),
                    Text("Đang tải thêm $itemPerPage dòng dữ liệu...")
                  ],
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
        onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
        ),
      ),
      buttonRight: InkWell(
        borderRadius: BorderRadius.circular(15),
        // onTap: () => Navigator.pushNamed(context, DefectAnalysisCreateScreen.routeName),
        child: Icon(Icons.addchart_outlined, color: kPrimaryColor, size: 30.0),
        onTap: () => showBarModalBottomSheet(
          context: context,
          builder: (context) => DefectAnalysisCreateScreen(),
        ).then((value) {
          setState(() {
            isLoading = false;
            _listOfDefectAnalysis = _getlistOfDefectAnalysis();
          });
          print('Modal bottom sheet closed');
        }),
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
                    trailing: state.selected.length > 0 ? CircleAvatar(radius: 15, backgroundColor: kPrimaryColor, child: Text('${state.selected.length}', style: TextStyle(color: Colors.white))) : null,
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
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DefaultButton(
                      text: "Đặt lại",
                      color: kTextColor,
                      press: () {
                        setState(() {
                          _projectsCurrent = [];
                          _statusCurrent = [];
                          _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: DefaultButton(
                      text: "Lọc dữ liệu",
                      press: () {
                        setState(() {
                          _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listAll(BuildContext context) {
    return Expanded(
      child: (isOnline)
          ? NotificationListener<ScrollNotification>(
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
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                  });
                },
                child: FutureBuilder<DefectAnalysisModels>(
                  future: _listOfDefectAnalysis,
                  builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget(message: "Không tìm thấy dữ liệu");

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                          child: GroupedListView<dynamic, String>(
                        elements: snapshot.data!.data,
                        groupBy: (element) => "${element.project.name} (${element.project.customer})",
                        groupSeparatorBuilder: (String value) => Container(
                          width: MediaQuery.of(context).size.width,
                          color: kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                            child: Text(
                              value,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
                        separator: Divider(thickness: 1),
                        floatingHeader: false,
                        useStickyGroupSeparators: true,
                      )),
                    );
                  },
                ),
              ),
            )
          : NoConnectionWidget(),
    );
  }

  Widget _item(DefectAnalysisModel item) {
    return ListTile(
      onTap: () => showBarModalBottomSheet(
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
                    Navigator.pushNamed(context, DefectAnalysisUpdateScreen.routeName, arguments: {'id': item.id, 'tabIndex': 0});
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
            children: [
              WidgetSpan(child: Icon(Icons.tag, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 3.0)),
              TextSpan(text: "${item.id}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
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
              TextSpan(text: "${DateFormat("hh:mm dd/MM/yyyy").format(item.analysisDate!)}", style: TextStyle(color: kTextColor)),
            ],
          )),
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
        await Maintenance.DefectAnalysis_Delete(key).then((response) {
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            ProgressHud.of(context)?.showSuccessAndDismiss(text: "Thành công");
            setState(() {
              isLoading = false;
              _listOfDefectAnalysis = _getlistOfDefectAnalysis();
            });
          } else {
            ProgressHud.of(context)?.showErrorAndDismiss(text: "Thất bại");
            Util.showNotification(context, "${response.body}", Colors.red, 5);
          }
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.showErrorAndDismiss(text: "Thất bại");
          Util.showNotification(context, "Có lỗi xảy ra. Chi tiết: $error", Colors.red, 5);
        });
      }
    });
  }
}
