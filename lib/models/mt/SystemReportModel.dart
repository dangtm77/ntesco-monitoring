// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../common/ProjectModel.dart';
import '../common/UserModel.dart';
import '../common/VariableModel.dart';
import 'SystemModel.dart';

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
  final int idProject;
  final ProjectModel project;
  final int idSystem;
  final SystemModel system;
  final String? code;
  final String staff;
  final UserModel staffInfo;
  final int? type;
  final VariableModel? typeInfo;

  final int status;
  final VariableModel statusInfo;

  final String? userCreate;
  final String? userUpdate;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;

  SystemReportModel({
    required this.id,
    required this.idProject,
    required this.project,
    required this.idSystem,
    required this.system,
    this.code,
    required this.staff,
    required this.staffInfo,
    this.type,
    this.typeInfo,
    required this.status,
    required this.statusInfo,
    this.userCreate,
    this.userUpdate,
    this.dateCreate,
    this.dateUpdate,
  });

  factory SystemReportModel.fromJson(dynamic json) {
    return SystemReportModel(
      id: json['id'] as int,
      idProject: json['idProject'] as int,
      project: ProjectModel.fromJson(json['project']),
      idSystem: json['idSystem'] as int,
      system: SystemModel.fromJson(json['system']),
      code: json['code'] as String,
      staff: json['staff'] as String,
      staffInfo: UserModel.fromJson(json['staffInfo']),
      type: json['type'] != null ? json['type'] as int : null,
      typeInfo: json['type'] != null ? VariableModel.fromJson(json['typeInfo']) : null,
      status: json['status'] as int,
      statusInfo: VariableModel.fromJson(json['statusInfo']),
      userCreate: json['userCreate'] != null ? json['userCreate'] as String : null,
      userUpdate: json['userUpdate'] != null ? json['userUpdate'] as String : null,
      dateCreate: json['dateCreate'] != null ? DateTime.parse(json['dateCreate']) : null,
      dateUpdate: json['dateUpdate'] != null ? DateTime.parse(json['dateUpdate']) : null,
    );
  }
}
