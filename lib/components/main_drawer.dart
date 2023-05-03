import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/defect_analysis_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/maintenance_screen.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/plan_screen.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:easy_localization/easy_localization.dart';

import '../size_config.dart';
import 'change_language.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => new _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late Future<LoginResponseModel> userCurrent;

  @override
  void initState() {
    super.initState();
    userCurrent = _getUserCurrent();
  }

  Future<LoginResponseModel> _getUserCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return LoginResponseModel.fromJson(json.decode(prefs.getString('USERCURRENT')!));
  }

  @override
  Widget build(BuildContext context) {
    var MenuList = [
      {
        "icon": Ionicons.home_outline,
        "text": "menu.home".tr(),
        "press": () => Navigator.pushNamed(context, HomeScreen.routeName),
      },
    ];

    return new FutureBuilder(
      future: userCurrent,
      builder: (_, AsyncSnapshot<LoginResponseModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: new Theme(
              data: Theme.of(context).copyWith(secondaryHeaderColor: Colors.blue),
              child: new CircularProgressIndicator(),
            ),
          );
        }
        LoginResponseModel? userCurrent = snapshot.data;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("language_display".tr(), style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600)), ChangeLanguage()],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 80.0, backgroundColor: kPrimaryColor, child: CircleAvatar(radius: 75.0, backgroundImage: NetworkImage(userCurrent!.anhDaiDien.toString()))),
                        SizedBox(height: 5.0),
                        Text(
                          "${userCurrent.hoTen}",
                          style: TextStyle(fontSize: getProportionateScreenWidth(15), fontWeight: FontWeight.w800, color: kPrimaryColor),
                        ),
                        SizedBox(height: 1.0),
                        Text(
                          "${userCurrent.chucDanh}",
                          style: TextStyle(fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.w400, color: kSecondaryColor),
                        ),
                        SizedBox(height: 1.0),
                        Text(
                          "${userCurrent.phongBan}",
                          style: TextStyle(fontSize: getProportionateScreenWidth(12), fontWeight: FontWeight.w400, color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                  title: Row(
                    children: [
                      Icon(
                        Ionicons.home_outline,
                        color: kPrimaryColor,
                        size: getProportionateScreenWidth(15),
                      ),
                      SizedBox(width: 10),
                      Text("menu.home".tr(), style: TextStyle(fontSize: getProportionateScreenWidth(13), color: kPrimaryColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
                  title: Row(
                    children: [
                      Icon(
                        Ionicons.git_compare_outline,
                        color: kPrimaryColor,
                        size: getProportionateScreenWidth(15),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "menu.phieudexuat".tr(),
                        style: TextStyle(
                          fontSize: kNormalFontSize,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Row(
                    children: [
                      Icon(Ionicons.construct_outline, color: kPrimaryColor, size: 15.0),
                      SizedBox(width: 10),
                      Text(
                        "menu.maintenance".tr(),
                        style: TextStyle(
                          fontSize: kNormalFontSize,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(context, PlanScreen.routeName),
                        title: Row(
                          children: [
                            Icon(Ionicons.newspaper_outline, color: kPrimaryColor, size: 15.0),
                            SizedBox(width: 10),
                            Text("Kế hoạch bảo trì", style: TextStyle(fontSize: kNormalFontSize, color: kPrimaryColor)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(context, MaintenanceScreen.routeName),
                        title: Row(
                          children: [
                            Icon(Ionicons.build_outline, color: kPrimaryColor, size: 15),
                            SizedBox(width: 10),
                            Text("Bảo trì hệ thống", style: TextStyle(fontSize: kNormalFontSize, color: kPrimaryColor)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(context, DefectAnalysisScreen.routeName),
                        title: Row(
                          children: [
                            Icon(Ionicons.shield_checkmark_outline, color: kPrimaryColor, size: 15.0),
                            SizedBox(width: 10),
                            Text("Phân tích sự cố", style: TextStyle(fontSize: kNormalFontSize, color: kPrimaryColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  onTap: () async {
                    if (await funcLogOut()) Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                  },
                  title: Row(
                    children: [
                      Icon(
                        Ionicons.log_out_outline,
                        color: kPrimaryColor,
                        size: getProportionateScreenWidth(15),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "menu.log_out".tr(),
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(13),
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
