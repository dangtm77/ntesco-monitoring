// ignore_for_file: non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:ntesco_smart_monitoring/core/core.dart' as Core;

const API_SYSTEMS_GETLIST = "v2/mt/systems";
const API_SYSTEMS_GETLIST_BYPROJECT = "v2/mt/systems/byproject";

const API_SYSTEMCONFIGS_GETLIST = "v2/mt/systemconfigs";

const API_PLANS_GETLIST = "v2/mt/plans";

const API_DEFECTANALYSIS_GETLIST = "v2/mt/defectanalysis";
const API_DEFECTANALYSIS_GETDETAIL = "v2/mt/defectanalysis/detail";
const API_DEFECTANALYSIS_SEND = "v2/mt/defectanalysis/send";

const API_DEFECTANALYSISDETAILS_GETLIST = "v2/mt/defectanalysisdetails";
const API_DEFECTANALYSISDETAILS_GETDETAIL = "v2/mt/defectanalysisdetails/detail";
const API_DEFECTANALYSISDETAILS_WITH_FILEDINHKEM = "v2/mt/defectanalysisdetails/withFileDinhKem";

const API_SYSTEM_REPORTS = "v2/mt/systemreports";
const API_SYSTEM_REPORTS_GETDETAIL = "v2/mt/systemreports/detail";

//--------------------------SYSTEMS--------------------------//
Future<http.Response> Systems_GetList(dynamic options) async => Core.get(options, API_SYSTEMS_GETLIST);
Future<http.Response> Systems_GetList_ByProject(int id, dynamic options) async {
  var queryParameters = options;
  queryParameters.addAll({"idProject": id.toString()});
  return Core.get(queryParameters, API_SYSTEMS_GETLIST_BYPROJECT);
}

//--------------------------SYSTEMCONFIGS--------------------------//
Future<http.Response> SystemConfigs_GetList(dynamic options) async => Core.get(options, API_SYSTEMCONFIGS_GETLIST);

//--------------------------PLANS--------------------------//
Future<http.Response> Plans_GetList(dynamic options) async => Core.get(options, API_PLANS_GETLIST);

//--------------------------DEFECT ANALYSIS--------------------------//
Future<http.Response> DefectAnalysis_GetDetail(dynamic options) async => Core.get(options, API_DEFECTANALYSIS_GETDETAIL);
Future<http.Response> DefectAnalysis_GetList(dynamic options) async => Core.get(options, API_DEFECTANALYSIS_GETLIST);
Future<http.Response> DefectAnalysis_Create(dynamic body) async => Core.post(body, API_DEFECTANALYSIS_GETLIST);
Future<http.Response> DefectAnalysis_Update(int key, dynamic body) async => Core.put(key, body, API_DEFECTANALYSIS_GETLIST);
Future<http.Response> DefectAnalysis_Delete(int key) async => Core.delete(key, API_DEFECTANALYSIS_GETLIST);
Future<http.Response> DefectAnalysis_Send(int key, dynamic body) async => Core.put(key, body, API_DEFECTANALYSIS_SEND);
//--------------------------DEFECT ANALYSIS DETAILS--------------------------//
Future<http.Response> DefectAnalysisDetails_GetList(int id, dynamic options) async {
  var queryParameters = options;
  queryParameters.addAll({"idDefectAnalysis": id.toString()});
  return Core.get(queryParameters, API_DEFECTANALYSISDETAILS_GETLIST);
}

Future<http.Response> DefectAnalysisDetails_GetDetail(dynamic options) async => Core.get(options, API_DEFECTANALYSISDETAILS_GETDETAIL);
Future<http.Response> DefectAnalysisDetails_Create(dynamic body) async => Core.post_by_model(body, API_DEFECTANALYSISDETAILS_GETLIST);
Future<http.Response> DefectAnalysisDetails_Update(int key, dynamic body) async => Core.put(key, body, API_DEFECTANALYSISDETAILS_GETLIST);
Future<http.Response> DefectAnalysisDetails_Delete(int key) async => Core.delete(key, API_DEFECTANALYSISDETAILS_GETLIST);

Future<http.Response> DefectAnalysisDetails_WithFileDinhKem_GetList(int id, dynamic options) async {
  var queryParameters = options;
  queryParameters.addAll({"id": id.toString()});
  return Core.get(queryParameters, API_DEFECTANALYSISDETAILS_WITH_FILEDINHKEM);
}

Future<http.Response> DefectAnalysisDetails_WithFileDinhKem_Create(dynamic body) async => Core.post_by_model(body, API_DEFECTANALYSISDETAILS_WITH_FILEDINHKEM);
Future<http.Response> DefectAnalysisDetails_WithFileDinhKem_Delete(int key) async => Core.delete(key, API_DEFECTANALYSISDETAILS_WITH_FILEDINHKEM);
//--------------------------SYSTEM REPORT--------------------------//
Future<http.Response> SystemReports_GetList(dynamic options) async => Core.get(options, API_SYSTEM_REPORTS);
Future<http.Response> SystemReports_GetDetail(dynamic options) async => Core.get(options, API_SYSTEM_REPORTS_GETDETAIL);
Future<http.Response> SystemReports_Create(dynamic body) async => Core.post(body, API_SYSTEM_REPORTS);
