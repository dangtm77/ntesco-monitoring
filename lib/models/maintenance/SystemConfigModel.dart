// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'SystemSpecificationModel.dart';

class SystemConfigModels {
  final int totalCount;
  final List<SystemConfigModel> data;
  SystemConfigModels({required this.totalCount, required this.data});
  factory SystemConfigModels.fromJson(dynamic json) {
    return SystemConfigModels(
        totalCount: json['totalCount'] as int,
        data: json['data'].map<SystemConfigModel>((json) {
          return SystemConfigModel.fromJson(json);
        }).toList());
  }
}

class SystemConfigModel {
  final int id;
  final int idSystem;
  final int idSystemSpecification;
  final int groupSortIndex;
  final String groupTitle;
  final String? standardValues;
  final bool isRequired;
  final bool isActive;
  final bool isDelete;
  final String? userCreate;
  final String? userUpdate;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;
  final int? sortIndex;
  final SystemSpecificationModel? specification;
  SystemConfigModel({
    required this.id,
    required this.idSystem,
    required this.idSystemSpecification,
    required this.groupSortIndex,
    required this.groupTitle,
    this.standardValues,
    required this.isRequired,
    required this.isActive,
    required this.isDelete,
    this.userCreate,
    this.userUpdate,
    this.dateCreate,
    this.dateUpdate,
    this.sortIndex,
    this.specification,
  });

  factory SystemConfigModel.fromJson(dynamic map) {
    return SystemConfigModel(
      id: map['id'] as int,
      idSystem: map['idSystem'] as int,
      groupSortIndex: map['groupSortIndex'] as int,
      groupTitle: map['groupTitle'] as String,
      idSystemSpecification: map['idSystemSpecification'] as int,
      standardValues: map['standardValues'] != null ? map['standardValues'] as String : null,
      isRequired: map['isRequired'] as bool,
      isActive: map['isActive'] as bool,
      isDelete: map['isDelete'] as bool,
      userCreate: map['userCreate'] != null ? map['userCreate'] as String : null,
      userUpdate: map['userUpdate'] != null ? map['userUpdate'] as String : null,
      dateCreate: map['dateCreate'] != null ? DateTime.parse(map['dateCreate']) : null,
      dateUpdate: map['dateUpdate'] != null ? DateTime.parse(map['dateUpdate']) : null,
      sortIndex: map['sortIndex'] != null ? map['sortIndex'] as int : null,
      specification: SystemSpecificationModel.fromJson(map['specification']),
    );
  }

  @override
  String toString() {
    return 'SystemConfigModel(id: $id, idSystem: $idSystem, idSystemSpecification: $idSystemSpecification, groupSortIndex: $groupSortIndex, groupTitle: $groupTitle, standardValues: $standardValues, isActive: $isActive, isDelete: $isDelete, userCreate: $userCreate, userUpdate: $userUpdate, dateCreate: $dateCreate, dateUpdate: $dateUpdate, sortIndex: $sortIndex, specification: $specification)';
  }
}
