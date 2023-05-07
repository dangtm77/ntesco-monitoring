// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import '../../defect_analysis_screen.dart';
import 'update/summary_pageview.dart';
import 'update/details_pageview.dart';
import 'update/comments_pageview.dart';

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

  Widget _header() {
    return Container(
      child: TopHeaderSub(
        title: "common.title_page_update_info".tr().toUpperCase(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushNamed(context, DefectAnalysisScreen.routeName),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 25.0)],
          ),
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Expanded(
      child: (isOnline)
          ? FutureBuilder<DefectAnalysisModel>(
              future: _defectAnalysis,
              builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModel> snapshot) {
                if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) return LoadingWidget();

                if (snapshot.hasData && snapshot.data != null) {
                  DefectAnalysisModel item = snapshot.data!;
                  return Scaffold(
                    body: SizedBox.expand(
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: ((value) => setState(() => _currentIndex = value)),
                        children: <Widget>[
                          SummaryPageView(id: item.id, model: item),
                          DetailsPageView(id: item.id, model: item),
                          CommentsPageView(id: item.id, model: item),
                        ],
                      ),
                    ),
                    bottomNavigationBar: BottomNavyBar(
                      iconSize: 25,
                      showElevation: false,
                      itemCornerRadius: 10.0,
                      containerHeight: 50.0,
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
                                Text('Thông tin', style: TextStyle(fontSize: kSmallerFontSize)),
                                Text('CHUNG', style: TextStyle(fontSize: kSmallFontSize, fontWeight: FontWeight.bold)),
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
                                Text('Chi tiết', style: TextStyle(fontSize: kSmallerFontSize)),
                                Text('SỰ CỐ', style: TextStyle(fontSize: kSmallFontSize, fontWeight: FontWeight.bold)),
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
                                Text('Ý kiến', style: TextStyle(fontSize: kSmallerFontSize)),
                                Text('PHẢN HỒI', style: TextStyle(fontSize: kSmallFontSize, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else
                  return NoDataWidget(subtitle: "Không tìm thấy thông tin phiếu liên quan đến bạn!!!");
              },
            )
          : NoConnectionWidget(),
    );
  }
}
