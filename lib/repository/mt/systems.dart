import 'dart:convert';

import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

import '../../models/LoadOptions.dart';
import '../../models/maintenance/SystemModel.dart';

class MaintenanceSystemsRepository {
  static Future<SystemModels> getListSystemsByIDProject(int id, dynamic option) async {
    try {
      List<dynamic> sortOptions = [], filterOptions = [];
      int takeOptions = 0, skipOptions = 0;

      LoadOptionsModel options = option != null
          ? option
          : new LoadOptionsModel(
              take: takeOptions,
              skip: skipOptions,
              sort: jsonEncode(sortOptions),
              filter: jsonEncode(filterOptions),
              requireTotalCount: 'true',
            );
      Response response = await Maintenance.Systems_GetList_ByProject(id, options.toMap());

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return SystemModels.fromJson(jsonDecode(response.body));
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }
}
