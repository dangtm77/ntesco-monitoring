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
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update_details.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update_summary.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class DefectAnalysisUpdateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis/update";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = int.parse(arguments['id'].toString());
    return Scaffold(drawerScrimColor: Colors.transparent, body: UpdateBody(id: id));
  }
}

class UpdateBody extends StatefulWidget {
  final int id;
  UpdateBody({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateBodyState createState() => new _UpdateBodyState(id);
}

class _UpdateBodyState extends State<UpdateBody> {
  final int id;
  _UpdateBodyState(this.id);

  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late int _currentIndex = 0;
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
        _currentIndex = 0;
        _pageController = PageController();
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
      print(result.id);
      return result;
    } else {
      throw Exception('StatusCode: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_header(), _main(context)],
          ),
        ),
      );

  Widget _header() => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis.update_title".tr(),
          subtitle: "maintenance.defect_analysis.update_subtitle",
          buttonLeft: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pop(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
        ),
      );

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
                              //physics: NeverScrollableScrollPhysics(),
                              onPageChanged: ((value) => setState(() => _currentIndex = value)),
                              children: <Widget>[
                                SummaryPageView(id: item.id, model: item),
                                DetailsPageView(id: item.id, model: item),
                              ],
                            ),
                          ),
                          bottomNavigationBar: BottomNavyBar(
                            showElevation: true,
                            itemCornerRadius: 10.0,
                            containerHeight: 45.0,
                            selectedIndex: _currentIndex,
                            onItemSelected: (value) {
                              setState(() => _currentIndex = value);
                              _pageController.jumpToPage(value);
                            },
                            items: <BottomNavyBarItem>[
                              BottomNavyBarItem(
                                title: Text('CHUNG'),
                                icon: Icon(Ionicons.reader_outline),
                                textAlign: TextAlign.center,
                              ),
                              BottomNavyBarItem(
                                title: Text('CHI TIẾT'),
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
      );
}
