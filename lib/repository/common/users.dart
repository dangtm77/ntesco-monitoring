import 'dart:convert';

import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;

import '../../models/LoadOptions.dart';
import '../../models/common/UserModel.dart';

class CommonUsersRepository {
  static Future<UserModels> getListUsers(dynamic option) async {
    try {
      List<dynamic> sortOptions = [
        {"selector": "phongBan_SapXep", "desc": "false"},
        {"selector": "chucDanh_SapXep", "desc": "true"},
      ];
      List<dynamic> filterOptions = [];
      int takeOptions = 0, skipOptions = 0;

      LoadOptionsModel options = (option != null)
          ? option
          : new LoadOptionsModel(
              take: takeOptions,
              skip: skipOptions,
              sort: jsonEncode(sortOptions),
              filter: jsonEncode(filterOptions),
              requireTotalCount: 'true',
            );
      Response response = await Common.Users_GetList(options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299)
        return UserModels.fromJson(jsonDecode(response.body));
      else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }
}
