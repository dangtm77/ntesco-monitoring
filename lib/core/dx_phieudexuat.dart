import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> getListPhieuDeXuat(int year, LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/dx/phieudexuat";
  var queryParameters = options.toMap();
  queryParameters.addAll({"year": year.toString()});

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}

Future<http.Response> getListTheoDoi(int id, LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/dx/phieudexuat/theodoi";
  var queryParameters = options.toMap();
  queryParameters.addAll({"id": id.toString()});

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}

Future<http.Response> getDetailPhieuDeXuat(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/dx/phieudexuat/byid";
  var queryParameters = new Map<String, dynamic>();
  queryParameters.addAll({"id": id.toString()});

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}

Future<http.Response> getListDanhMuc(LoadOptionsModel options) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/dx/danhmuc/lookup";
  var queryParameters = options.toMap();

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}

Future<http.Response> getDetailThongKe(int year) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USERCURRENT')!));
  var headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};

  var api = "v2/dx/PhieuDeXuat/ThongKe";
  var queryParameters = {"year": year.toString(), "type": "ByAll"};

  final response = await http.get(Uri.https(endPoint, api, queryParameters), headers: headerValue);
  return response;
}
