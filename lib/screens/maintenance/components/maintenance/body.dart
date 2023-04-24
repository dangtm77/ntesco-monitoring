// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
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
import '../../../../models/mt/SystemReportsModel.dart';
import '../../../../repository/mt/systems.dart';
import '../../../../size_config.dart';
import '../../../home/home_screen.dart';
import 'create.dart';

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
  late Future<SystemReportsModels> _listOfSystemReports;

  @override
  void initState() {
    super.initState();
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;
        _isLoading = false;
        _listOfSystemReports = _getlistOfSystemReports();
      });
    });
  }

  Future<SystemReportsModels> _getlistOfSystemReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;

    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [];
    // //FILTER BY PROJECT
    // List<dynamic> projectsFilterOptions = [];
    // projectsFilterOptions.add(['idProject', '=', _projectCurrent]);
    // if (projectsFilterOptions.length > 0) {
    //   if (filterOptions.length > 0) filterOptions.add('and');
    //   if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
    // }

    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.SystemReports_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      SystemReportsModels result = SystemReportsModels.fromJson(jsonDecode(response.body));
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
        onPressed: () => (_projectCurrent != 0) ? showModalBottomSheet(context: context, builder: (context) => _selectSystemForCreate(context)) : null,
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
                    _isLoading = false;
                    _listOfSystemReports = _getlistOfSystemReports();
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _isLoading = false;
                    _listOfSystemReports = _getlistOfSystemReports();
                  });
                },
                child: FutureBuilder<SystemReportsModels>(
                  future: _listOfSystemReports,
                  builder: (BuildContext context, AsyncSnapshot<SystemReportsModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !_isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty))
                      return NoDataWidget(
                        subtitle: "Vui lòng kiểm tra lại điều kiện lọc hoặc liên hệ trực tiếp đến quản trị viên...",
                        button: DefaultButton(
                          text: "Tải lại",
                          press: () {
                            setState(() {
                              _isLoading = false;
                              _listOfSystemReports = _getlistOfSystemReports();
                            });
                          },
                        ),
                      );

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                          child: GroupedListView<dynamic, String>(
                        elements: snapshot.data!.data,
                        //groupBy: (element) => "${element.project.name} (${element.project.customer})",
                        groupBy: (element) => "${element.idSystem}",
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
                              child: FadeInAnimation(child: Text(item.code)),
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
              builder: (BuildContext context, AsyncSnapshot<SystemModels> snapshot) {
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MaintenanceCreateScreen(systemModel: element)));
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
}
