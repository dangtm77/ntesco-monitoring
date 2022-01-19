import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> funcGetListContactUs(LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!)); 
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "/app/valuecustoms";

  var uri = Uri.https(endPoint, api, options.toMap());
  final response = await http.get(uri, headers: headerValue);
  return response;
}
