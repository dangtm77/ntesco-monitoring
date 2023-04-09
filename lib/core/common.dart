// ignore_for_file: non_constant_identifier_names
import 'package:http/http.dart' as http;
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/core.dart' as Core;

const API_PROJECTS_LOOKUP = "v2/common/projects/lookup";
const API_USERS_LOOKUP = "v2/common/users/lookup";
const API_VARIABLES_LOOKUP = "v2/common/variables/lookup";

String System_DowloadFile_ByID(int ID, String? TYPE) => "https://$endPoint/v1/HeThong/FileDinhKem/Download?id=$ID&type=${(TYPE ?? "view")}";

Future<http.Response> Projects_GetList(dynamic options) async => Core.get(options, API_PROJECTS_LOOKUP);
Future<http.Response> Users_GetList(dynamic options) async => Core.get(options, API_USERS_LOOKUP);
Future<http.Response> Variables_GetList(dynamic options) async => Core.get(options, API_VARIABLES_LOOKUP);
