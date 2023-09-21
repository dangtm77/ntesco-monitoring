// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:ntesco_smart_monitoring/core/core.dart' as Core;
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/LoadOptions.dart';
import '../../models/Login.dart';
import '../../models/maintenance/SystemReportReplacementsModel.dart';

class MaintenanceSystemReportReplacementsRepository {
  static String API_SYSTEM_REPORTS_REPLACEMENTS = "v2/mt/systemreportreplacements";

  static Future<SystemReportReplacementsModels> getList(int idSystemReport) async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      filterOptions.add(['idSystemReport', '=', idSystemReport]);
      int takeOptions = 0, skipOptions = 0;
      LoadOptionsModel options = new LoadOptionsModel(take: takeOptions, skip: skipOptions, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Core.get(options.toMap(), API_SYSTEM_REPORTS_REPLACEMENTS);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return SystemReportReplacementsModels.fromJson(jsonDecode(response.body));
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  static Future<SystemReportReplacementsModel> getDetail(int id) async {
    try {
      var options = new Map<String, dynamic>();
      options.addAll({"id": id.toString()});
      Response response = await Core.get(options, API_SYSTEM_REPORTS_REPLACEMENTS + "/detail");
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return SystemReportReplacementsModel.fromJson(jsonDecode(response.body));
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  static Future<http.Response> create(dynamic body) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      LoginResponseModel userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USER_CURRENT')!));
      Map<String, String> headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};
      var data = [
        {"Key": "values", "Value": jsonEncode(body)}
      ];
      print(jsonEncode(data));
      return await http.post(
        Uri.https(endPoint, API_SYSTEM_REPORTS_REPLACEMENTS),
        headers: headerValue,
        body: jsonEncode(data),
      );
    } catch (ex) {
      throw ex;
    }
  }

  static Future<http.Response> update(int key, dynamic body) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      LoginResponseModel userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USER_CURRENT')!));
      Map<String, String> headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};
      var data = [
        {"Key": "key", "Value": key},
        {"Key": "values", "Value": jsonEncode(body)}
      ];
      print(jsonEncode(data));
      return await http.put(
        Uri.https(endPoint, API_SYSTEM_REPORTS_REPLACEMENTS),
        headers: headerValue,
        body: jsonEncode(data),
      );
    } catch (ex) {
      throw ex;
    }
  }

  static Future<http.Response> delete(int key) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      LoginResponseModel userCurrent = LoginResponseModel.fromJson(json.decode(preferences.getString('USER_CURRENT')!));
      Map<String, String> headerValue = <String, String>{'Content-Type': 'application/json', 'Authorization': 'Bearer ${userCurrent.accessToken}'};
      var data = [
        {"Key": "key", "Value": key},
      ];
      return await http.delete(
        Uri.https(endPoint, API_SYSTEM_REPORTS_REPLACEMENTS),
        headers: headerValue,
        body: jsonEncode(data),
      );
    } catch (ex) {
      throw ex;
    }
  }
}
