import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/dx_phieudexuat.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/components/detail_chung_body.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/components/detail_thaoluan_body.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/components/detail_theodoi_body.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';

class Body extends StatefulWidget {
  final int id;
  Body({Key? key, required this.id}) : super(key: key);

  @override
  _BodyPageState createState() => new _BodyPageState(id);
}

class _BodyPageState extends State<Body> {
  final int id;
  _BodyPageState(this.id);

  late int _currentIndex = 0;
  late PageController _pageController;
  late Future<PhieuDeXuatDetailModel> _phieuDeXuat;

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    _phieuDeXuat = _getDetailPhieuDeXuat();
    super.initState();
  }

  Future<PhieuDeXuatDetailModel> _getDetailPhieuDeXuat() async {
    var response = await getDetailPhieuDeXuat(id);
    if (response.statusCode == 200)
      return PhieuDeXuatDetailModel.fromJson(jsonDecode(response.body));
    else if (response.statusCode == 401)
      throw response.statusCode;
    else
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
            Container(
              child: TopHeaderSub(
                title: "phieudexuat.detail_title".tr(),
                subtitle: "phieudexuat.detail_subtitle".tr(),
                buttonLeft: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      Icon(
                        Ionicons.chevron_back_outline,
                        color: kPrimaryColor,
                        size: 35.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<PhieuDeXuatDetailModel>(
                future: _phieuDeXuat,
                builder: (BuildContext context, AsyncSnapshot<PhieuDeXuatDetailModel> snapshot) {
                  if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                  if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)) return LoadingWidget();

                  if (snapshot.hasData && snapshot.data != null) {
                    var item = snapshot.data;
                    return Scaffold(
                      body: SizedBox.expand(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: ((value) => setState(() => _currentIndex = value)),
                          children: <Widget>[
                            DetailChungBody(id: id, phieuDeXuat: item),
                            DetailTheoDoiBody(id: id, phieuDeXuat: item),
                            DetailThaoLuanBody(id: id, phieuDeXuat: item),
                            //Container(color: Colors.blue),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomNavyBar(
                        itemCornerRadius: 10.0,
                        containerHeight: 45.0,
                        selectedIndex: _currentIndex,
                        onItemSelected: (value) {
                          setState(() => _currentIndex = value);
                          _pageController.jumpToPage(value);
                        },
                        items: <BottomNavyBarItem>[
                          BottomNavyBarItem(
                            title: Text('Chung'),
                            icon: Icon(Ionicons.reader_outline),
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            title: Text('Phê duyệt'),
                            icon: Icon(Ionicons.git_branch_outline),
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            title: Text('Trao đổi'),
                            icon: Icon(Ionicons.chatbubbles_outline),
                            textAlign: TextAlign.center,
                          ),
                          //BottomNavyBarItem(title: Text('Khác'), icon: Icon(Ionicons.ellipsis_horizontal_circle_outline), textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  } else {
                    return NoDataWidget(message: "Không tìm thấy thông tin phiếu đề xuất!!!");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
