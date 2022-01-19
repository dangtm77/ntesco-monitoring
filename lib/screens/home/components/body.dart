import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';  
import '../../../size_config.dart'; 
import 'dart:convert';

import '../../../components/top_header.dart';
import 'banner.dart'; 

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
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

  Future<void> _refreshUserCurrent() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      userCurrent = _getUserCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new RefreshIndicator(
          color: Colors.red,
          onRefresh: _refreshUserCurrent,
          child: FutureBuilder(
              future: userCurrent,
              builder: (_, AsyncSnapshot<LoginResponseModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: new Theme(
                      data: Theme.of(context).copyWith(accentColor: Colors.blue),
                      child: new CircularProgressIndicator(),
                    ),
                  );
                } 
                LoginResponseModel? userCurrent = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [  
                      SizedBox(height: getProportionateScreenHeight(15)),
                      TopHeader(),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      HeaderBanner(model: userCurrent)
                    ],
                  ),
                );
              })),
    );
  }
}
