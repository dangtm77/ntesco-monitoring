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
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/mt/PlanModel.dart';
import 'package:ntesco_smart_monitoring/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../repository/common/projects.dart';

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

  late int _projectCurrent = 0;
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
        _isLoading = false;
        _listOfPlans = _getListOfPlans();
      });
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = false;
      _listOfPlans = _getListOfPlans();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<PlanModels> _getListOfPlans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;

    List<dynamic> sortOptions = [
      {"selector": "fullPath", "desc": "false"},
      {"selector": "startDate", "desc": "true"},
      {"selector": "endDate", "desc": "true"}
    ];
    List<dynamic> filterOptions = [];
    //FILTER BY PROJECT
    List<dynamic> projectsFilterOptions = [];
    projectsFilterOptions.add(['idProject', '=', _projectCurrent]);
    if (projectsFilterOptions.length > 0) {
      if (filterOptions.length > 0) filterOptions.add('and');
      if (projectsFilterOptions.length > 0) filterOptions.add(projectsFilterOptions);
    }

    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.Plans_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      PlanModels result = PlanModels.fromJson(jsonDecode(response.body));
      setState(() {
        _isLoading = false;
      });
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
          children: [
            _header(context),
            _listAll(context),
            AnimatedOpacity(
              opacity: _isLoading ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: 30.0,
                color: kPrimaryColor,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                          height: 10.0,
                          width: 10.0),
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
      title: "maintenance.plan.title".tr(),
      subtitle: "maintenance.plan.subtitle".tr(),
      buttonLeft: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pop(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 25.0)],
        ),
      ),
      buttonRight: IconButton(
        enableFeedback: true,
        color: (_projectCurrent != 0) ? kPrimaryColor : Colors.grey,
        icon: Icon(Ionicons.filter_outline, size: 25.0),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => _filter(_),
        ),
      ),
    );
  }

  Widget _filter(BuildContext context) {
    Future<List<S2Choice<int>>> projectFilter = CommonProjectsRepository.getListProjectsForSelect();

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
                      icon: Icons.restart_alt,
                      text: "Đặt lại",
                      color: kTextColor,
                      press: () {
                        setState(() {
                          _projectCurrent = 0;
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
                      icon: Icons.filter_alt,
                      text: "Lọc dữ liệu",
                      press: () {
                        setState(() {
                          _isLoading = false;
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
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading && scrollInfo.metrics.maxScrollExtent != 0.0 && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _listOfPlans = _getListOfPlans();
                    _isLoading = true;
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _isLoading = false;
                    _listOfPlans = _getListOfPlans();
                  });
                },
                child: FutureBuilder<PlanModels>(
                  future: _listOfPlans,
                  builder: (BuildContext context, AsyncSnapshot<PlanModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !_isLoading) return LoadingWidget();
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
                      return NoDataWidget(
                        subtitle: "Vui lòng kiểm tra lại điều kiện lọc...",
                        button: OutlinedButton.icon(
                            onPressed: _refresh,
                            icon: Icon(Ionicons.refresh, size: 22.0),
                            label: Text(
                              'Refresh',
                              style: TextStyle(fontSize: kNormalFontSize),
                            )),
                      );
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
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
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: kNormalFontSize,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 5.0),
              Text.rich(TextSpan(
                children: [
                  WidgetSpan(child: Icon(Ionicons.calendar_outline, size: 13.0, color: kTextColor)),
                  WidgetSpan(child: SizedBox(width: 4.0)),
                  TextSpan(
                    text: "${DateFormat("dd/MM/yyyy").format(item.startDate!)} - ${DateFormat("dd/MM/yyyy").format(item.endDate!)}",
                    style: TextStyle(color: kTextColor, fontWeight: FontWeight.normal, fontSize: 11.0, fontStyle: FontStyle.normal),
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
