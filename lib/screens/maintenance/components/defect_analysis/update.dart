import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class MaintenanceDefectAnalysisUpdateScreen extends StatelessWidget {
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

  late int _currentIndex = 0;
  late PageController _pageController;
  late Future<DefectAnalysisModel> _defectAnalysis;

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    _defectAnalysis = _getDetailOfDefectAnalysis();
    super.initState();
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
            children: <Widget>[
              _header(),
            ],
          ),
        ),
      );

  Widget _header() => Container(
        child: TopHeaderSub(
          title: "maintenance.defect_analysis.create_title".tr(),
          subtitle: "maintenance.defect_analysis.create_subtitle",
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

  @override
  void dispose() {
    super.dispose();
  }
}
