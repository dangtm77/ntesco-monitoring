import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/UsersModel.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'dart:convert';

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

  Future<UsersModels> _getlistOfUsers() async {
    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [];
    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Common.Users_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      UsersModels result = UsersModels.fromJson(response.body);
      return result;
    } else
      throw Exception(response.body);
  }

  Future<void> _refreshUserCurrent() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      userCurrent = _getUserCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    _getlistOfUsers().then((values) {
      values.data.forEach((element) {
        print(element.toString());
      });
    });

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
                      data: Theme.of(context).copyWith(secondaryHeaderColor: Colors.blue),
                      child: new CircularProgressIndicator(),
                    ),
                  );
                }
                LoginResponseModel? userCurrent = snapshot.data;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    SizedBox(height: getProportionateScreenHeight(15)),
                    TopHeader(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    HeaderBanner(model: userCurrent),
                  ]),
                );
              })),
    );
  }
}
