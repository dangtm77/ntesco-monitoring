import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/auth.dart';
import 'package:ntesco_smart_monitoring/screens/home/home_screen.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/dexuat_screen.dart';
import 'package:ntesco_smart_monitoring/screens/signin/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:easy_localization/easy_localization.dart';

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
              children: [
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
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: kPrimaryColor),
                        ),
                        SizedBox(height: 1.0),
                        Text(
                          "${userCurrent.chucDanh}",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: kSecondaryColor),
                        ),
                        SizedBox(height: 1.0),
                        Text(
                          "${userCurrent.phongBan}",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                  leading: Icon(Icons.home_rounded, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title: Text("menu.home".tr(), style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, ListOfDeXuatScreen.routeName),
                  leading: Icon(Icons.bar_chart_rounded, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title: Text("menu.phieudexuat".tr(), style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
                /*
                ListTile(
                  onTap: () => Navigator.pushNamed(context, ReportsScreen.routeName),
                  leading: Icon(Icons.bar_chart_rounded, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title:
                      Text("menu.reports".tr(), style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  onTap: () => Navigator.pushNamed(context, ContactUsScreen.routeName),
                  leading: Icon(Icons.insert_comment_outlined, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title: Text("menu.contact_us".tr(),
                      style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  onTap: () => {},
                  leading: Icon(Icons.warning_amber_rounded, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title: Text("menu.alarm".tr(),
                      style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
                */
                ListTile(
                  onTap: () async {
                    if (await funcLogOut()) Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                  },
                  leading: Icon(Icons.power_settings_new_rounded, color: kPrimaryColor),
                  trailing: Icon(Icons.arrow_right_rounded, color: kPrimaryColor),
                  title: Text("menu.log_out".tr(), style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
