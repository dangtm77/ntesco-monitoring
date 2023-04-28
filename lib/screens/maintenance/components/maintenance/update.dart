// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemReportModel.dart';

import '../../../../components/state_widget.dart';
import '../../../../components/top_header.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../maintenance_screen.dart';
import 'update/replacements_pageview.dart';
import 'update/reviews_pageview.dart';
import 'update/summary_pageview.dart';

class MaintenanceUpdateScreen extends StatelessWidget {
  static String routeName = "/mt/maintenance/update";
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
  late Future<SystemReportModel> _systemReport;

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
        _systemReport = _getDetailOfSystemReport();
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<SystemReportModel> _getDetailOfSystemReport() async {
    var options = new Map<String, dynamic>();
    options.addAll({"id": id.toString()});
    Response response = await Maintenance.SystemReports_GetDetail(options);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      SystemReportModel result = SystemReportModel.fromJson(jsonDecode(response.body));
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
          children: <Widget>[_header(context), _main(context)],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      child: TopHeaderSub(
        title: "maintenance.defect_analysis.update_title".tr(),
        subtitle: "maintenance.defect_analysis.update_subtitle".tr(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushNamed(context, MaintenanceScreen.routeName),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Expanded(
      child: (isOnline)
          ? FutureBuilder<SystemReportModel>(
              future: _systemReport,
              builder: (BuildContext context, AsyncSnapshot<SystemReportModel> snapshot) {
                if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) return LoadingWidget();
                if (snapshot.hasData && snapshot.data != null) {
                  SystemReportModel item = snapshot.data!;
                  return Scaffold(
                    body: SizedBox.expand(
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: ((value) => setState(() => _currentIndex = value)),
                        children: <Widget>[
                          SummaryPageView(id: item.id, model: item),
                          ReplacementPageView(id: item.id, model: item),
                          ReviewsPageView(id: item.id, model: item),
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
                          icon: Icon(Ionicons.repeat_outline),
                          textAlign: TextAlign.center,
                          title: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vật liệu cần', style: TextStyle(fontSize: 15)),
                                Text('THAY THẾ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        BottomNavyBarItem(
                          icon: Icon(Icons.star_half_outlined),
                          textAlign: TextAlign.center,
                          title: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thông tin', style: TextStyle(fontSize: 15)),
                                Text('Đánh giá', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else
                  return NoDataWidget(subtitle: "Không tìm thấy thông tin liên quan đến bạn!!!");
              },
            )
          : NoConnectionWidget(),
    );
  }
}
