import 'dart:convert';

import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

import '../../models/LoadOptions.dart';
import '../../models/maintenance/SystemConfigModel.dart';

class MaintenanceSystemConfigsRepository {
  static Future<SystemConfigModels> getListSystemConfigs(int idSystem) async {
    try {
      List<dynamic> sortOptions = [
        {"selector": "groupSortIndex", "desc": "false"},
        {"selector": "sortIndex", "desc": "false"},
      ];
      List<dynamic> filterOptions = [
        ['idSystem', '=', idSystem]
      ];
      int takeOptions = 0, skipOptions = 0;

      LoadOptionsModel options = new LoadOptionsModel(
        take: takeOptions,
        skip: skipOptions,
        sort: jsonEncode(sortOptions),
        filter: jsonEncode(filterOptions),
        requireTotalCount: 'true',
      );
      Response response = await Maintenance.SystemConfigs_GetList(options.toMap());

      print(response.body);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return SystemConfigModels.fromJson(jsonDecode(response.body));
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }
}
