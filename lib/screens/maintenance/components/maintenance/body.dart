// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';

import '../../../../components/state_widget.dart';
import '../../../../constants.dart';
import '../../../../models/LoadOptions.dart';
import '../../../../models/common/ProjectModel.dart';
import '../../../../models/mt/SystemModel.dart';
import '../../../../models/mt/SystemReportModel.dart';
import '../../../../repository/mt/systems.dart';
import '../../../../size_config.dart';
import '../../../home/home_screen.dart';
import 'create.dart';
import 'update.dart';

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

  late TextEditingController _keywordForSearchEditingController = TextEditingController();

  late int _projectCurrent = 0;
  late Future<SystemReportModels> _listOfSystemReports;

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
        _listOfSystemReports = _getlistOfSystemReports();
      });
    });
  }

  Future<SystemReportModels> _getlistOfSystemReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;

    List<dynamic> sortOptions = [
      //{"selector": "dateCreate", "desc": "true"}
    ];
    List<dynamic> filterOptions = [];
    //FILTER BY PROJECT
    List<dynamic> projectsFilterOptions = [];
    projectsFilterOptions.add(['system.idProject', '=', _projectCurrent]);
    if (projectsFilterOptions.length > 0) {
      if (filterOptions.length > 0) filterOptions.add('and');
      if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
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
      // searchGroupFilterOptions.add('or');
      // searchGroupFilterOptions.add(['project.code', 'contains', _keyword]);
      // searchGroupFilterOptions.add('or');
      // searchGroupFilterOptions.add(['project.contractNo', 'contains', _keyword]);
      // searchGroupFilterOptions.add('or');
      // searchGroupFilterOptions.add(['project.name', 'contains', _keyword]);
      filterOptions.add(searchGroupFilterOptions);
    }

    LoadOptionsModel options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.SystemReports_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      SystemReportModels result = SystemReportModels.fromJson(jsonDecode(response.body));
      setState(() {
        _isLoading = false;
      });
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
              height: _isLoading ? 30.0 : 0,
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
      title: "maintenance.title".tr(),
      subtitle: "maintenance.subtitle".tr(),
      buttonLeft: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
        ),
      ),
      buttonRight: IconButton(
        enableFeedback: true,
        color: (_projectCurrent != 0) ? kPrimaryColor : Colors.grey,
        icon: Icon(Icons.addchart_outlined, size: 30.0),
        onPressed: () => (_projectCurrent != 0) ? showModalBottomSheet(context: context, builder: (_) => _selectSystemForCreate(_)) : null,
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
                _isLoading = false;
                _listOfSystemReports = _getlistOfSystemReports();
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
                            _isLoading = false;
                            _listOfSystemReports = _getlistOfSystemReports();
                          });
                        },
                        icon: Icon(Ionicons.close_circle, color: Colors.grey.shade500, size: 20),
                      ),
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                        builder: (BuildContext context) => _filter(context),
                        context: context,
                      ).then((e) {
                        setState(() {
                          _isLoading = false;
                          _listOfSystemReports = _getlistOfSystemReports();
                        });
                      }),
                      icon: Icon(
                        Ionicons.filter,
                        color: (_projectCurrent != 0) ? kPrimaryColor : Colors.grey.shade500,
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
                    trailing: state.selected.length > 0 ? CircleAvatar(radius: 15, backgroundColor: kPrimaryColor, child: Text('${state.selected.length}', style: TextStyle(color: Colors.white))) : null,
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
                        setState(() {});
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
                          _isLoading = false;
                          _listOfSystemReports = _getlistOfSystemReports();
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
                if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _listOfSystemReports = _getlistOfSystemReports();
                    _isLoading = true;
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _isLoading = false;
                    _listOfSystemReports = _getlistOfSystemReports();
                  });
                },
                child: FutureBuilder<SystemReportModels>(
                  future: _listOfSystemReports,
                  builder: (BuildContext context, AsyncSnapshot<SystemReportModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !_isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget(subtitle: "Vui lòng kiểm tra lại điều kiện lọc hoặc liên hệ trực tiếp đến quản trị viên...");

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                        child: GroupedListView<dynamic, String>(
                          elements: snapshot.data!.data,
                          groupBy: (element) => "${element.system.name}" + (element.system.otherName != null ? " (${element.system.otherName})" : ""),
                          groupSeparatorBuilder: (String value) => Container(
                            width: MediaQuery.of(context).size.width,
                            color: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                              child: Text(value, textAlign: TextAlign.left, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _item(SystemReportModel item) {
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
                      Text('Xem & chỉnh sửa thông tin', style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, MaintenanceUpdateScreen.routeName, arguments: {'id': item.id, 'tabIndex': 0});
                  },
                ),
                ListTile(
                  trailing: Icon(Ionicons.arrow_forward, color: kPrimaryColor),
                  title: Row(
                    children: [
                      Icon(Ionicons.trash_bin_outline, color: Colors.red),
                      SizedBox(width: 10.0),
                      Text('Hủy bỏ thông tin', style: TextStyle(color: Colors.red, fontSize: 18)),
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
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
            children: [
              TextSpan(text: "${item.code}", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
              TextSpan(text: "${item.statusInfo.text}", style: TextStyle(color: item.status == 0 ? kWarningColor : kPrimaryColor)),
              WidgetSpan(child: SizedBox(width: 5.0)),
            ],
          )),
          SizedBox(height: 5.0),
          Text.rich(TextSpan(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
            children: [
              WidgetSpan(child: Icon(Icons.tag, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 2.0)),
              TextSpan(text: "${item.id}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.label_important_rounded, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 2.0)),
              TextSpan(text: "${item.typeInfo?.text ?? "Chưa xác định"}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.person_add_alt_1, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 2.0)),
              TextSpan(text: "${item.staffInfo.hoTen}", style: TextStyle(color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 15.0)),
              WidgetSpan(child: Icon(Icons.calendar_month, size: 18, color: kTextColor)),
              WidgetSpan(child: SizedBox(width: 2.0)),
              TextSpan(text: "${DateFormat("hh:mm dd/MM/yy").format(item.dateCreate!)}", style: TextStyle(color: kTextColor)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _selectSystemForCreate(BuildContext context) {
    Future<SystemModels> _listOfSystems = MaintenanceSystemsRepository.getListSystemsByIDProject(_projectCurrent, null);
    return Scrollbar(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Vui lòng chọn hệ thống cần thực hiện bảo trì...", style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
            ),
          ),
          Expanded(
            child: FutureBuilder<SystemModels>(
              future: _listOfSystems,
              builder: (BuildContext _, AsyncSnapshot<SystemModels> snapshot) {
                if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) return LoadingWidget();
                if (!snapshot.hasData && !snapshot.data!.data.isNotEmpty) return NoDataWidget();

                return AnimationLimiter(
                  child: ListView.separated(
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      SystemModel element = snapshot.data!.data.elementAt(index);
                      return ListTile(
                        title: Text(
                          element.name.toString() + (element.otherName != null ? (' (' + element.otherName.toString() + ')') : ''),
                          style: const TextStyle(fontSize: 15.0, color: kPrimaryColor, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "Mã ${element.code.toString()} - Ngày bàn giao ${DateFormat("dd/MM/yyyy").format(element.dateAcceptance!)}",
                          style: const TextStyle(fontSize: 13.0),
                        ),
                        trailing: Icon(Ionicons.arrow_forward, color: kSecondaryColor, size: 18.0),
                        onTap: () {
                          Navigator.pop(context);
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => MaintenanceCreateScreen(systemModel: element),
                            isDismissible: false,
                            enableDrag: false,
                          ).then((value) {
                            setState(() {
                              pageIndex = pageIndex + 1;
                              _isLoading = false;
                              _listOfSystemReports = _getlistOfSystemReports();
                            });
                          });
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => MaintenanceCreateScreen(systemModel: element)));
                        },
                      );
                    }, // optional
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                );
              },
            ),
          )
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
            ProgressHud.of(context)?.dismiss();
            Util.showNotification(context, null, "Hủy bỏ thông tin thành công", ContentType.success, 3);
            setState(() {
              _isLoading = false;
              _listOfSystemReports = _getlistOfSystemReports();
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
