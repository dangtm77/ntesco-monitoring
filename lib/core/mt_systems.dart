import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';

Future<http.Response> getList(LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/mt/systems";

  final response = await http.get(Uri.https(endPoint, api, options.toMap()), headers: headerValue);
  return response;
}

Future<http.Response> getListByProject(int id, LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/mt/systems/byproject";
  var queryParameters = new Map<String, dynamic>();
  queryParameters.addAll({"idProject": id.toString()});

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}
