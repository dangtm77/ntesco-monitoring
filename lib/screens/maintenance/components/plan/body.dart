import 'dart:async';
import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
import 'package:ntesco_smart_monitoring/models/mt/PlanModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late List<int> _projectsCurrent = [];
  late Future<PlanModels> _listOfPlans;

  @override
  void initState() {
    super.initState();
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _listOfPlans = _getListOfPlans();
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<PlanModels> _getListOfPlans() async {
    List<dynamic> sortOptions = [
      {"selector": "fullPath", "desc": "false"},
      {"selector": "startDate", "desc": "true"},
      {"selector": "endDate", "desc": "true"}
    ];
    List<dynamic> filterOptions = [];
    //FILTER BY PROJECT
    if (_projectsCurrent.isNotEmpty && _projectsCurrent.length > 0) {
      List<dynamic> projectsFilterOptions = [];
      _projectsCurrent.forEach((id) {
        projectsFilterOptions.add(['idProject', '=', id]);
        projectsFilterOptions.add("or");
      });
      if (projectsFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        if (projectsFilterOptions.last == "or") projectsFilterOptions.removeAt(projectsFilterOptions.length - 1);
        if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
      }
    }

    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.Plans_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299)
      return PlanModels.fromJson(jsonDecode(response.body));
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<List<S2Choice<int>>> _getListProjectsForSelect() async {
    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [];
    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Common.Projects_GetList(options.toMap());

    if (response.statusCode >= 200 && response.statusCode <= 299)
      return S2Choice.listFrom<int, dynamic>(
        source: ProjectModels.fromJson(jsonDecode(response.body)).data,
        value: (index, item) => item.id,
        title: (index, item) => item.name,
      );
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
      title: "maintenance.plan_title".tr(),
      subtitle: "maintenance.plan_subtitle".tr(),
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
                          _listOfPlans = _getListOfPlans();
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
                          _listOfPlans = _getListOfPlans();
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
              child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _listOfPlans = _getListOfPlans();
                });
              },
              child: FutureBuilder<PlanModels>(
                future: _listOfPlans,
                builder: (BuildContext context, AsyncSnapshot<PlanModels> snapshot) {
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
                            child: ListView.builder(
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
                            ),
                          ),
                        );
                      } else
                        return NoDataWidget(message: "Không tìm thấy phiếu đề xuất nào liên quan đến bạn !!!");
                    }
                  }
                },
              ),
            ))
          : NoConnectionWidget(),
    );
  }

  Widget _item(PlanModel item) {
    if (item.idParent == null)
      return Container(
        width: MediaQuery.of(context).size.width,
        color: kPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          child: Text(
            "${item.stt}. ${item.title}",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    // return ListTile(
    //   leading: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         item.stt,
    //         style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 15.0, fontStyle: FontStyle.normal),
    //       ),
    //     ],
    //   ),
    //   title: Text(
    //     "PROJECT",
    //     style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 15.0, fontStyle: FontStyle.italic),
    //   ),
    //   subtitle: Text(
    //     item.title,
    //     style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 15.0, fontStyle: FontStyle.normal),
    //   ),
    // );
    else {
      double levelSpace = (item.level - 1) * 25.0;
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.stt,
              style: TextStyle(color: kTextColor, fontWeight: FontWeight.normal, fontSize: 15.0, fontStyle: FontStyle.normal),
            ),
          ],
        ),
        title: Padding(
          padding: EdgeInsets.only(left: levelSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w700, fontSize: 15.0, fontStyle: FontStyle.normal),
              ),
              SizedBox(height: 5.0),
              Text.rich(TextSpan(
                children: [
                  WidgetSpan(child: Icon(Ionicons.calendar_outline, size: 17.0, color: kTextColor)),
                  WidgetSpan(child: SizedBox(width: 4.0)),
                  TextSpan(
                    text: "${DateFormat("dd/MM/yyyy").format(item.startDate!)} - ${DateFormat("dd/MM/yyyy").format(item.endDate!)}",
                    style: TextStyle(color: kTextColor, fontWeight: FontWeight.normal, fontSize: 15.0, fontStyle: FontStyle.italic),
                  ),
                ],
              )),
            ],
          ),
        ),
        // subtitle: (item.participantsInfo != null)
        //     ? Padding(
        //         padding: EdgeInsets.only(left: levelSpace),
        //         child: ,
        //       )
        //     : null,
        //trailing: _trangThaiIcon,
        //onTap: () => Navigator.pushNamed(context, DetailOfDeXuatScreen.routeName, arguments: {'id': item.id}),
      );
    }
  }
}
