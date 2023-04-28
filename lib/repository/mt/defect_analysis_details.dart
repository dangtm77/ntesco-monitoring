import 'dart:convert';

import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

import '../../models/LoadOptions.dart';
import '../../models/mt/DefectAnalysisDetailsModel.dart';

class MaintenanceDefectAnalysisDetailsRepository {
  static Future<DefectAnalysisDetailsModels> getList(int id, dynamic option) async {
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
      Response response = await Maintenance.DefectAnalysisDetails_GetList(id, options.toMap());

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        var rs = DefectAnalysisDetailsModels.fromJson(jsonDecode(response.body));
        return rs;
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }
}
