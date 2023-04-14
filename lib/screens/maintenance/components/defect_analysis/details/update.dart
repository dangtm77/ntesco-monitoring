// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/size_config.dart';

import '../../../../../components/top_header.dart';
import '../../../../../constants.dart';
import '../../../../../helper/util.dart';
import '../../../../../models/mt/DefectAnalysisDetailsModel.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

class DefectAnalysisDetailsUpdateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis-details/update";
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
  late Future<DefectAnalysisDetailsModel> _defectAnalysisDetails;

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
        _defectAnalysisDetails = _getDetailOfDefectAnalysisDetails();
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<DefectAnalysisDetailsModel> _getDetailOfDefectAnalysisDetails() async {
    var options = new Map<String, dynamic>();
    options.addAll({"id": id.toString()});
    Response response = await Maintenance.DefectAnalysisDetails_GetDetail(options);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      DefectAnalysisDetailsModel result = DefectAnalysisDetailsModel.fromJson(jsonDecode(response.body));
      return result;
    } else {
      throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_currentIndex);
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_header()],
        ),
      ),
    );
  }

  Widget _header() => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis_details.update_title".tr(),
          subtitle: "maintenance.defect_analysis_details.update_subtitle",
          buttonLeft: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => {},
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
        ),
      );
/*
  Widget _main(BuildContext context) => Expanded(
        child: (isOnline)
            ? FutureBuilder<DefectAnalysisModel>(
                future: _defectAnalysis,
                builder: (BuildContext context, AsyncSnapshot<DefectAnalysisModel> snapshot) {
                  if (snapshot.hasError) {
                    return DataErrorWidget(error: snapshot.error.toString());
                  } else {
                    if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                      return LoadingWidget();
                    else {
                      if (snapshot.hasData && snapshot.data != null) {
                        var item = snapshot.data!;
                        return Scaffold(
                          body: SizedBox.expand(
                            child: PageView(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: ((value) => setState(() => _currentIndex = value)),
                              children: <Widget>[
                                SummaryPageView(id: item.id, model: item),
                                DetailsPageView(id: item.id, model: item),
                              ],
                            ),
                          ),
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Thông tin'),
                                    Text('CHUNG', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                icon: Icon(Ionicons.reader_outline),
                                textAlign: TextAlign.center,
                              ),
                              BottomNavyBarItem(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Chi tiết'),
                                    Text('SỰ CỐ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                icon: Icon(Ionicons.git_branch_outline),
                                textAlign: TextAlign.center,
                              ),
                              //BottomNavyBarItem(title: Text('Khác'), icon: Icon(Ionicons.ellipsis_horizontal_circle_outline), textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      } else {
                        return NoDataWidget(message: "Không tìm thấy thông tin phiếu đề xuất!!!");
                      }
                    }
                  }
                },
              )
            : NoConnectionWidget(),
      );*/
}
