// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SystemReportModels {
  final int totalCount;
  final List<SystemReportModel> data;
  SystemReportModels({
    required this.totalCount,
    required this.data,
  });
  factory SystemReportModels.fromJson(dynamic json) {
    return SystemReportModels(
        totalCount: json['totalCount'],
        data: json['data'].map<SystemReportModel>((json) {
          return SystemReportModel.fromJson(json);
        }).toList());
  }
}

class SystemReportModel {
  final int id;
  final int idSystem;
  final String code;
  final int totalDetail;
  SystemReportModel({
    required this.id,
    required this.idSystem,
    required this.code,
    required this.totalDetail,
  });

  factory SystemReportModel.fromJson(dynamic json) {
    return SystemReportModel(
      id: json['id'] as int,
      idSystem: json['idSystem'] as int,
      code: json['code'] as String,
      totalDetail: json['totalDetail'] as int,
    );
  }
}
