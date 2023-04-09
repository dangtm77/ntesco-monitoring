import 'package:ntesco_smart_monitoring/models/common/FileDinhKemModel.dart';

class DefectAnalysisDetailsModels {
  final int totalCount;
  final List<DefectAnalysisDetailsModel> data;
  DefectAnalysisDetailsModels({required this.totalCount, required this.data});
  factory DefectAnalysisDetailsModels.fromJson(dynamic json) {
    return DefectAnalysisDetailsModels(
        totalCount: json['totalCount'],
        data: json['data'].map<DefectAnalysisDetailsModel>((json) {
          return DefectAnalysisDetailsModel.fromJson(json);
        }).toList());
  }
}

class DefectAnalysisDetailsModel {
  final int id;
  final int idDefectAnalysis;
  final String? partName;
  final int? partQuantity;
  final String? partManufacturer;
  final String? partModel;
  final String? partSpecifications;
  final String? analysisProblemCause;
  final String? solution;
  final String? departmentInCharge;
  final String? executionTime;
  final String? note;
  final String? maintenanceStaffComment;
  final String? qcStaffComment;
  final String? cncStaffComment;
  final bool isActive;
  final bool isDelete;
  final String? userCreate;
  final String? userUpdate;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;
  final int sortIndex;
  final FileDinhKemModel pictures;
  DefectAnalysisDetailsModel({
    required this.id,
    required this.idDefectAnalysis,
    this.partName,
    this.partQuantity,
    this.partManufacturer,
    this.partModel,
    this.partSpecifications,
    this.analysisProblemCause,
    this.solution,
    this.departmentInCharge,
    this.executionTime,
    this.note,
    this.maintenanceStaffComment,
    this.qcStaffComment,
    this.cncStaffComment,
    required this.isActive,
    required this.isDelete,
    this.userCreate,
    this.userUpdate,
    this.dateCreate,
    this.dateUpdate,
    required this.sortIndex,
    required this.pictures,
  });

  factory DefectAnalysisDetailsModel.fromJson(dynamic map) {
    return DefectAnalysisDetailsModel(
      id: map['id'] as int,
      idDefectAnalysis: map['idDefectAnalysis'] as int,
      partName: map['partName'] != null ? map['partName'] as String : null,
      partQuantity: map['partQuantity'] != null ? map['partQuantity'] as int : null,
      partManufacturer: map['partManufacturer'] != null ? map['partManufacturer'] as String : null,
      partModel: map['partModel'] != null ? map['partModel'] as String : null,
      partSpecifications: map['partSpecifications'] != null ? map['partSpecifications'] as String : null,
      analysisProblemCause: map['analysisProblemCause'] != null ? map['analysisProblemCause'] as String : null,
      solution: map['solution'] != null ? map['solution'] as String : null,
      departmentInCharge: map['departmentInCharge'] != null ? map['departmentInCharge'] as String : null,
      executionTime: map['executionTime'] != null ? map['executionTime'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      maintenanceStaffComment: map['maintenanceStaffComment'] != null ? map['maintenanceStaffComment'] as String : null,
      qcStaffComment: map['qcStaffComment'] != null ? map['qcStaffComment'] as String : null,
      cncStaffComment: map['cncStaffComment'] != null ? map['cncStaffComment'] as String : null,
      isActive: map['isActive'] as bool,
      isDelete: map['isDelete'] as bool,
      userCreate: map['userCreate'] != null ? map['userCreate'] as String : null,
      userUpdate: map['userUpdate'] != null ? map['userUpdate'] as String : null,
      dateCreate: map['dateCreate'] != null ? DateTime.parse(map['dateCreate']) : null,
      dateUpdate: map['dateUpdate'] != null ? DateTime.parse(map['dateUpdate']) : null,
      sortIndex: map['sortIndex'] as int,
      pictures: map['pictures'].map<FileDinhKemModel>((json) {
        return FileDinhKemModel.fromJson(json);
      }).toList(),
    );
  }
}
