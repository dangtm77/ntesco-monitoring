// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SystemReportsModels {
  final int totalCount;
  final List<SystemReportsModel> data;
  SystemReportsModels({
    required this.totalCount,
    required this.data,
  });
  factory SystemReportsModels.fromJson(dynamic json) {
    return SystemReportsModels(
        totalCount: json['totalCount'],
        data: json['data'].map<SystemReportsModel>((json) {
          return SystemReportsModel.fromJson(json);
        }).toList());
  }
}

class SystemReportsModel {
  final int id;
  final int idSystem;
  final String code;
  final int totalDetail;
  SystemReportsModel({
    required this.id,
    required this.idSystem,
    required this.code,
    required this.totalDetail,
  });

  factory SystemReportsModel.fromJson(dynamic json) {
    return SystemReportsModel(
      id: json['id'] as int,
      idSystem: json['idSystem'] as int,
      code: json['code'] as String,
      totalDetail: json['totalDetail'] as int,
    );
  }
}
