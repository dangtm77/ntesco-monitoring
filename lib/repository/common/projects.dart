import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;

import '../../models/LoadOptions.dart';
import '../../models/common/ProjectModel.dart';

class CommonProjectsRepository {
  static Future<ProjectModels> getListProjects(dynamic option) async {
    try {
      List<dynamic> sortOptions = [], filterOptions = [];
      int takeOptions = 0, skipOptions = 0;

      LoadOptionsModel options = new LoadOptionsModel(take: takeOptions, skip: skipOptions, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      if (option != null) options = options;

      Response response = await Common.Projects_GetList(options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return ProjectModels.fromJson(jsonDecode(response.body));
      else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  static Future<List<S2Choice<int>>> getListProjectsForSelect() async {
    List<dynamic> sortOptions = [], filterOptions = [];
    int takeOptions = 0, skipOptions = 0;

    LoadOptionsModel options = new LoadOptionsModel(take: takeOptions, skip: skipOptions, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Common.Projects_GetList(options.toMap());

    if (response.statusCode >= 200 && response.statusCode <= 299)
      return S2Choice.listFrom<int, dynamic>(
        source: ProjectModels.fromJson(jsonDecode(response.body)).data,
        value: (index, item) => item.id,
        title: (index, item) => item.name,
      );
    else
      throw Exception(response.body);
  }
}
