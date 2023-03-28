// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';

class PlanModels {
  final int totalCount;
  final List<PlanModel> data;
  PlanModels({
    required this.totalCount,
    required this.data,
  });
  factory PlanModels.fromJson(dynamic json) {
    return PlanModels(
        totalCount: json['totalCount'],
        data: json['data'].map<PlanModel>((json) {
          return PlanModel.fromJson(json);
        }).toList());
  }
}

class PlanModel {
  final String stt;
  final int level;
  final int id;
  final int? idParent;
  final int idProject;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? participants;
  final List<NguoiDungModel>? participantsInfo;
  final String linkIDs;
  final bool isActive;
  final bool isDelete;
  final String? userCreate;
  final String? userUpdate;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;
  final int sortIndex;
  PlanModel({
    required this.stt,
    required this.id,
    required this.level,
    this.idParent,
    required this.idProject,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.participants,
    this.participantsInfo,
    required this.linkIDs,
    required this.isActive,
    required this.isDelete,
    this.userCreate,
    this.userUpdate,
    this.dateCreate,
    this.dateUpdate,
    required this.sortIndex,
  });

  factory PlanModel.fromJson(dynamic json) {
    return PlanModel(
      stt: json['stt'] as String,
      level: json['level'] as int,
      id: json['id'] as int,
      idParent: json['idParent'] != null ? json['idParent'] as int : null,
      idProject: json['idProject'] as int,
      title: json['title'] as String,
      startDate: json['startDate'] != null ? DateTime.parse((json['startDate'])) : null,
      endDate: json['endDate'] != null ? DateTime.parse((json['endDate'])) : null,
      participants: (json['participants'] != null && json['participants'].length > 1) ? json['participants'] as String : null,
      participantsInfo: (json['participantsInfo'] != null && json['participantsInfo'].length > 1)
          ? json['participantsInfo'].map<NguoiDungModel>((json) {
              return NguoiDungModel.fromJson(json);
            }).toList()
          : null,
      linkIDs: json['linkIDs'] as String,
      isActive: json['isActive'] as bool,
      isDelete: json['isDelete'] as bool,
      userCreate: json['userCreate'] as String,
      userUpdate: json['userUpdate'] as String,
      dateCreate: json['dateCreate'] != null ? DateTime.parse((json['dateCreate'])) : null,
      dateUpdate: json['dateUpdate'] != null ? DateTime.parse((json['dateUpdate'])) : null,
      sortIndex: json['sortIndex'] as int,
    );
  }
}
