// ignore_for_file: non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:ntesco_smart_monitoring/core/core.dart' as Core;

const API_SYSTEMS_GETLIST = "v2/mt/systems";
const API_SYSTEMS_GETLIST_BYPROJECT = "v2/mt/systems/byproject";

const API_PLANS_GETLIST = "v2/mt/plans";

const API_DEFECTANALYSIS_GETLIST = "v2/mt/defectanalysis";

//--------------------------SYSTEMS--------------------------//
Future<http.Response> Systems_GetList(dynamic options) async => Core.get(options.toMap(), API_SYSTEMS_GETLIST);
Future<http.Response> Systems_GetList_ByProject(int id, dynamic options) async {
  var queryParameters = options.toMap();
  queryParameters.addAll({"idProject": id.toString()});
  return Core.get(queryParameters, API_SYSTEMS_GETLIST_BYPROJECT);
}

//--------------------------PLANS--------------------------//
Future<http.Response> Plans_GetList(dynamic options) async => Core.get(options.toMap(), API_PLANS_GETLIST);

//--------------------------DEFECT ANALYSIS--------------------------//
Future<http.Response> DefectAnalysis_GetList(dynamic options) async => Core.get(options.toMap(), API_DEFECTANALYSIS_GETLIST);
Future<http.Response> DefectAnalysis_Create(dynamic body) async => Core.post(body, API_DEFECTANALYSIS_GETLIST);
