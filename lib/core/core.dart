import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';

Future<http.Response> get(dynamic queryParameters, String urlApi) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};
  return await http.get(Uri.https(endPoint, urlApi, queryParameters), headers: headerValue);
}

Future<http.Response> post(dynamic body, String urlApi) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  LoginResponseModel userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  Map<String, String> headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};
  var data = [
    {"Key": "values", "Value": body}
  ];
  return await http.post(
    Uri.https(endPoint, urlApi),
    headers: headerValue,
    body: jsonEncode(data),
  );
}
