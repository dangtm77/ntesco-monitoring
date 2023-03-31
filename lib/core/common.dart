import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> getListProjects(LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/common/projects/lookup";
  final response = await http.get(Uri.https(endPoint, api, options.toMap()), headers: headerValue);
  return response;
}

Future<http.Response> getListVariables(LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var queryParameters = options.toMap();
  queryParameters.addAll({"groupValue": 'MAINTENANCE_DEFECT_ANALYSIS_STATUS'});

  var api = "/v2/common/variables/lookup";
  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}
