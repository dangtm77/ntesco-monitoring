// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SystemSpecificationModels {
  final int totalCount;
  final List<SystemSpecificationModel> data;
  SystemSpecificationModels({required this.totalCount, required this.data});
  factory SystemSpecificationModels.fromJson(dynamic json) {
    return SystemSpecificationModels(
        totalCount: json['totalCount'] as int,
        data: json['data'].map<SystemSpecificationModel>((json) {
          return SystemSpecificationModel.fromJson(json);
        }).toList());
  }
}

class SystemSpecificationModel {
  final int id;
  final int? groupSortIndex;
  final String? group;
  final String? title;
  final String? dataType;
  final String? dataValues;
  final String? dataUnit;
  final int? sortIndex;
  SystemSpecificationModel({
    required this.id,
    this.groupSortIndex,
    this.group,
    this.title,
    this.dataType,
    this.dataValues,
    this.dataUnit,
    this.sortIndex,
  });

  factory SystemSpecificationModel.fromJson(dynamic map) {
    return SystemSpecificationModel(
      id: map['id'] as int,
      groupSortIndex: map['groupSortIndex'] != null ? map['groupSortIndex'] as int : null,
      group: map['group'] != null ? map['group'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      dataType: map['dataType'] != null ? map['dataType'] as String : null,
      dataValues: map['dataValues'] != null ? map['dataValues'] as String : null,
      dataUnit: map['dataUnit'] != null ? map['dataUnit'] as String : null,
      sortIndex: map['sortIndex'] != null ? map['sortIndex'] as int : null,
    );
  }

  @override
  String toString() {
    return 'SystemSpecificationModel(id: $id, groupSortIndex: $groupSortIndex, group: $group, title: $title, dataType: $dataType, dataValues: $dataValues, dataUnit: $dataUnit, sortIndex: $sortIndex)';
  }
}
