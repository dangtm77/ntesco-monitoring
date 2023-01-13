import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/list_of_dexuat_screen.dart';

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

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
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
            Container(
              child: TopHeaderSub(
                title: "phieudexuat.detail_title".tr(),
                subtitle: "phieudexuat.detail_subtitle".tr(),
                buttonLeft: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 35.0)],
                  ),
                ),
                buttonRight: null,
              ),
            ),
            Expanded(
              child: Scaffold(
                body: SizedBox.expand(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: ((value) => setState(() => _currentIndex = value)),
                    children: <Widget>[
                      Container(color: Colors.blueGrey),
                      Container(color: Colors.red),
                      Container(color: Colors.green),
                      Container(color: Colors.blue),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavyBar(
                  backgroundColor: Colors.transparent,
                  itemCornerRadius: 10.0,
                  containerHeight: 45.0,
                  selectedIndex: _currentIndex,
                  onItemSelected: (value) {
                    setState(() => _currentIndex = value);
                    _pageController.jumpToPage(value);
                  },
                  items: <BottomNavyBarItem>[
                    BottomNavyBarItem(title: Text('Chung'), icon: Icon(Icons.home), textAlign: TextAlign.center),
                    BottomNavyBarItem(title: Text('Phê duyệt'), icon: Icon(Icons.apps), textAlign: TextAlign.center),
                    BottomNavyBarItem(title: Text('Trao đổi'), icon: Icon(Icons.chat_bubble), textAlign: TextAlign.center),
                    BottomNavyBarItem(title: Text('Khác'), icon: Icon(Icons.settings), textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
