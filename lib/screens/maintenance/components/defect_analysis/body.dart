import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
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
//import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/create.dart';
//import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/string.dart';

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
  late bool _isLoading = false;

  TextEditingController _keywordForSearchEditingController = TextEditingController();

  late int _projectCurrent = 0;
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
        _isLoading = false;
        _listOfDefectAnalysis = _getlistOfDefectAnalysis();
      });
    });
  }

  Future<DefectAnalysisModels> _getlistOfDefectAnalysis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;

    List<dynamic> sortOptions = [
      {"selector": "analysisDate", "desc": "true"},
      {"selector": "dateCreate", "desc": "true"}
    ];
    List<dynamic> filterOptions = [];
    //FILTER BY PROJECT
    List<dynamic> projectsFilterOptions = [];
    projectsFilterOptions.add(['system.idProject', '=', _projectCurrent]);
    if (projectsFilterOptions.length > 0) {
      if (filterOptions.length > 0) filterOptions.add('and');
      if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
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
      //searchGroupFilterOptions.add('or');
      //searchGroupFilterOptions.add(['project.code', 'contains', _keyword]);
      //searchGroupFilterOptions.add('or');
      //searchGroupFilterOptions.add(['project.contractNo', 'contains', _keyword]);
      //searchGroupFilterOptions.add('or');
      //searchGroupFilterOptions.add(['project.name', 'contains', _keyword]);
      filterOptions.add(searchGroupFilterOptions);
    }
    LoadOptionsModel options = new LoadOptionsModel(
      take: itemPerPage * pageIndex,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    Response response = await Maintenance.DefectAnalysis_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      setState(() => _isLoading = false);
      DefectAnalysisModels result = DefectAnalysisModels.fromJson(jsonDecode(response.body));
      return result;
    } else
      throw Exception(response.body);
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
    } else
      throw Exception(response.body);
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
    } else
      throw Exception(response.body);
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = false;
      _listOfDefectAnalysis = _getlistOfDefectAnalysis();
    });
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
            AnimatedOpacity(
              opacity: _isLoading ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: _isLoading ? 30.0 : 0,
                color: kPrimaryColor,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2), height: 10.0, width: 10.0),
                      SizedBox(width: 10.0),
                      Text(
                        "Đang tải thêm $itemPerPage dòng dữ liệu...",
                        style: TextStyle(color: Colors.white, fontSize: kSmallFontSize),
                      )
                    ],
                  ),
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
      title: "maintenance.defect_analysis.title".tr().toUpperCase(),
      subtitle: "maintenance.defect_analysis.subtitle".tr(),
      buttonLeft: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 25.0)],
        ),
      ),
      buttonRight: IconButton(
        enableFeedback: true, color: (_projectCurrent != 0) ? kPrimaryColor : Colors.grey, icon: Icon(Icons.addchart_outlined, size: 25.0), onPressed: () => {},
        // onPressed: () => (_projectCurrent != 0)
        //     ? showModalBottomSheet(
        //         context: context,
        //         builder: (context) => DefectAnalysisCreateScreen(),
        //       ).then((value) => _refresh())
        //     : null,
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
            if (value.isNotEmpty && value.trim().length > 3) _refresh();
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
                          });
                          _refresh();
                        },
                        icon: Icon(Ionicons.close_circle, color: Colors.grey.shade500, size: 20),
                      ),
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        builder: (BuildContext context) => _filter(context),
                        context: context,
                      ).then((e) => _refresh()),
                      icon: Icon(
                        Ionicons.filter,
                        color: (_statusCurrent.length > 0 || _projectCurrent != 0) ? kPrimaryColor : Colors.grey.shade500,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: kNormalFontSize, color: Colors.grey.shade500),
              hintText: "common.text_input_forsearch_hint".tr()),
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
              return SmartSelect<int>.single(
                title: 'Xem theo dự án',
                placeholder: "Vui lòng chọn ít nhất 1 dự án",
                modalFilter: true,
                selectedValue: _projectCurrent,
                choiceItems: snapshot.data,
                modalHeader: true,
                choiceType: S2ChoiceType.chips,
                modalType: S2ModalType.bottomSheet,
                onChange: (state) async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setInt('MAINTENANCE-IDPROJECT', state.value);
                  setState(() => _projectCurrent = state.value);
                },
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
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
                modalHeader: true,
                selectedValue: _statusCurrent,
                choiceItems: snapshot.data,
                choiceType: S2ChoiceType.chips,
                modalType: S2ModalType.bottomSheet,
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
                      text: "button.reset".tr(),
                      icon: Icons.restart_alt_rounded,
                      color: kTextColor,
                      press: () {
                        setState(() {
                          _projectCurrent = 0;
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
                      icon: Icons.filter_alt_rounded,
                      text: "button.filter".tr(),
                      press: () {
                        setState(() {
                          _isLoading = false;
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
                if (!_isLoading && scrollInfo.metrics.maxScrollExtent != 0.0 && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _listOfDefectAnalysis = _getlistOfDefectAnalysis();
                    _isLoading = true;
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async => _refresh(),
                child: FutureBuilder<DefectAnalysisModels>(
                  future: _listOfDefectAnalysis,
                  builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !_isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty))
                      return NoDataWidget(subtitle: "Vui lòng kiểm tra lại điều kiện lọc...");
                    else
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10.0),
                          horizontal: getProportionateScreenWidth(0.0),
                        ),
                        child: AnimationLimiter(
                          child: GroupedListView<dynamic, String>(
                            elements: snapshot.data!.data,
                            groupBy: (element) => element.system.name,
                            groupSeparatorBuilder: (String value) => Container(
                              width: MediaQuery.of(context).size.width,
                              color: kPrimaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(value, style: const TextStyle(fontSize: kNormalFontSize, fontWeight: FontWeight.bold, color: Colors.white)),
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
                            separator: Divider(thickness: 5),
                            floatingHeader: false,
                            useStickyGroupSeparators: true,
                          ),
                        ),
                      );
                  },
                ),
              ),
            )
          : NoConnectionWidget(),
    );
  }

  Widget _item(DefectAnalysisModel item) {
    List<Widget> _listMenu = [
      ListTile(
        title: Row(
          children: [
            Icon(Ionicons.create_outline, color: kPrimaryColor, size: 20),
            SizedBox(width: 10.0),
            Text("common.list_menu_button_update".tr(), style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize)),
          ],
        ),
        onTap: () async {
          Navigator.of(context).pop();
          //Navigator.pushNamed(context, DefectAnalysisUpdateScreen.routeName, arguments: {'id': item.id, 'tabIndex': 0});
        },
      ),
      // Visibility(
      //   visible: (item.status > 0 && item.totalDetail > 0),
      //   child: ListTile(
      //     title: Row(
      //       children: [
      //         Icon(Ionicons.cloud_download_outline, color: kPrimaryColor, size: 20),
      //         SizedBox(width: 10.0),
      //         Text("common.list_menu_button_export".tr(), style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize)),
      //       ],
      //     ),
      //     onTap: () async => exportFunc(item.id),
      //   ),
      // ),
      // Visibility(
      //   visible: (item.status == 0 && item.totalDetail > 0),
      //   child: ListTile(
      //     title: Row(
      //       children: [
      //         Icon(Ionicons.send_outline, color: kPrimaryColor, size: 20),
      //         SizedBox(width: 10.0),
      //         Text("common.list_menu_button_send_report".tr(), style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize)),
      //       ],
      //     ),
      //     onTap: () async => sendFunc(item.id),
      //   ),
      // ),
      ListTile(
        title: Row(
          children: [
            Icon(Ionicons.trash_bin_outline, color: Colors.red, size: 20),
            SizedBox(width: 10.0),
            Text("common.list_menu_button_delete".tr(), style: TextStyle(color: Colors.red, fontSize: kNormalFontSize)),
          ],
        ),
        onTap: () async => deleteFunc(item.id),
      ),
    ];

    return ListTile(
      dense: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: item.code, style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
            WidgetSpan(
              child: Visibility(
                visible: isMobile(),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: kTextColor, fontSize: kSmallFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
                    children: [
                      WidgetSpan(child: SizedBox(width: 5.0)),
                      TextSpan(text: DateFormat("hh:mm dd/MM/yy").format(item.analysisDate!), style: TextStyle(color: kTextColor, fontSize: kSmallFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ),
            WidgetSpan(
              child: Visibility(
                visible: !isMobile(),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: kTextColor, fontSize: kSmallFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
                    children: [
                      WidgetSpan(child: SizedBox(width: 5.0)),
                      TextSpan(text: DateFormat("hh:mm dd/MM/yy").format(item.analysisDate!), style: TextStyle(color: kTextColor, fontSize: kSmallFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                      WidgetSpan(child: SizedBox(width: 10.0)),
                      WidgetSpan(child: Icon(Icons.person, size: 15)),
                      WidgetSpan(child: SizedBox(width: 2.0)),
                      TextSpan(text: "${StringHelper.toShortName(item.analysisBy!)}"),
                      WidgetSpan(child: SizedBox(width: 10.0)),
                      WidgetSpan(child: Icon(Icons.label_important_rounded, size: 15)),
                      WidgetSpan(child: SizedBox(width: 0.0)),
                      TextSpan(text: "${item.statusInfo.text} (${item.processConfirm})"),
                      WidgetSpan(child: SizedBox(width: 10.0)),
                      WidgetSpan(child: Icon(Icons.label_important_rounded, size: 15)),
                      WidgetSpan(child: SizedBox(width: 0.0)),
                      TextSpan(text: "Có ${item.totalDetail} sự cố"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: isMobile()
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(color: kTextColor, fontSize: kSmallFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
                    children: [
                      WidgetSpan(child: Icon(Icons.person, size: 15)),
                      WidgetSpan(child: SizedBox(width: 2.0)),
                      TextSpan(text: "${StringHelper.toShortName(item.analysisBy!)}"),
                      WidgetSpan(child: SizedBox(width: 10.0)),
                      WidgetSpan(child: Icon(Icons.label_important_rounded, size: 15)),
                      WidgetSpan(child: SizedBox(width: 0.0)),
                      TextSpan(text: "${item.statusInfo.text} (${item.processConfirm})"),
                      WidgetSpan(child: SizedBox(width: 10.0)),
                      WidgetSpan(child: Icon(Icons.label_important_rounded, size: 15)),
                      WidgetSpan(child: SizedBox(width: 0.0)),
                      TextSpan(text: "Có ${item.totalDetail} sự cố"),
                    ],
                  ),
                )
              ],
            )
          : null,
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => Material(
          child: SafeArea(top: true, child: Column(mainAxisSize: MainAxisSize.min, children: _listMenu)),
        ),
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
            ProgressHud.of(context)?.dismiss();
            Util.showNotification(context, null, "Hủy bỏ thông tin thành công", ContentType.success, 3);
            _refresh();
          } else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }

  Future<void> sendFunc(key) async {
    Navigator.of(context).pop();
    showOkCancelAlertDialog(
      context: context,
      title: "XÁC NHẬN THÔNG TIN",
      message: "Bạn có chắc chắn là muốn gửi thông tin phân tích sự cố này đi không?",
      okLabel: "Gửi đi",
      cancelLabel: "Đóng lại",
      isDestructiveAction: true,
    ).then((result) async {
      if (result == OkCancelResult.ok) {
        ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
        var defectAnalysisModel = {'status': 1};
        await Maintenance.DefectAnalysis_Send(key, defectAnalysisModel).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, null, "Gửi thông tin đi thành công", ContentType.success, 3);
            _refresh();
          } else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }

  Future<void> exportFunc(key) async {
    await launchUrl(Uri.parse('https://portal-api.ntesco.com/v2/MT/DefectAnalysis/Export?id=2'), mode: LaunchMode.inAppWebView);
  }
}
