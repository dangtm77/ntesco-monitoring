// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';
import 'package:ntesco_smart_monitoring/models/common/VariableModel.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemModel.dart';

class DefectAnalysisModels {
  final int totalCount;
  final List<DefectAnalysisModel> data;
  DefectAnalysisModels({required this.totalCount, required this.data});
  factory DefectAnalysisModels.fromJson(dynamic json) {
    return DefectAnalysisModels(
        totalCount: json['totalCount'],
        data: json['data'].map<DefectAnalysisModel>((json) {
          return DefectAnalysisModel.fromJson(json);
        }).toList());
  }
}

class DefectAnalysisModel {
  final int id;
  final int idSystem;
  final String code;
  final DateTime? analysisDate;
  final String? analysisBy;
  final NguoiDungModel? analysisByInfo;
  final String? currentSuitation;
  final String? maintenanceStaff;
  final DateTime? maintenanceStaffConfirmDate;
  final String? maintenanceStaffComment;
  final String? qcStaff;
  final DateTime? qcStaffConfirmDate;
  final String? qcStaffComment;
  final String? cncStaff;
  final DateTime? cncStaffConfirmDate;
  final String? cncStaffComment;
  final int status;
  late final VariableModel statusInfo;
  final bool isDelete;
  final bool isActive;
  final String? userCreate;
  final String? userUpdate;
  final DateTime? dateCreate;
  final DateTime? dateUpdate;
  final int sortIndex;
  final int totalDetail;
  final SystemModel system;
  DefectAnalysisModel({
    required this.id,
    required this.idSystem,
    required this.code,
    this.analysisDate,
    this.analysisBy,
    this.analysisByInfo,
    this.currentSuitation,
    this.maintenanceStaff,
    this.maintenanceStaffConfirmDate,
    this.maintenanceStaffComment,
    this.qcStaff,
    this.qcStaffConfirmDate,
    this.qcStaffComment,
    this.cncStaff,
    this.cncStaffConfirmDate,
    this.cncStaffComment,
    required this.status,
    required this.statusInfo,
    required this.isDelete,
    required this.isActive,
    this.userCreate,
    this.userUpdate,
    this.dateCreate,
    this.dateUpdate,
    required this.sortIndex,
    required this.totalDetail,
    required this.system,
  });

  factory DefectAnalysisModel.fromJson(dynamic map) {
    return DefectAnalysisModel(
      id: map['id'] as int,
      idSystem: map['idSystem'] as int,
      code: map['code'] as String,
      analysisDate: map['analysisDate'] != null ? DateTime.parse(map['analysisDate']) : null,
      analysisBy: map['analysisBy'] != null ? map['analysisBy'] as String : null,
      analysisByInfo: map['analysisByInfo'] != null ? NguoiDungModel.fromJson(map['analysisByInfo']) : null,
      currentSuitation: map['currentSuitation'] != null ? map['currentSuitation'] as String : null,
      maintenanceStaff: map['maintenanceStaff'] != null ? map['maintenanceStaff'] as String : null,
      maintenanceStaffConfirmDate: map['maintenanceStaffConfirmDate'] != null ? DateTime.parse(map['maintenanceStaffConfirmDate']) : null,
      maintenanceStaffComment: map['maintenanceStaffComment'] != null ? map['maintenanceStaffComment'] as String : null,
      qcStaff: map['qcStaff'] != null ? map['qcStaff'] as String : null,
      qcStaffConfirmDate: map['qcStaffConfirmDate'] != null ? DateTime.parse(map['qcStaffConfirmDate']) : null,
      qcStaffComment: map['qcStaffComment'] != null ? map['qcStaffComment'] as String : null,
      cncStaff: map['cncStaff'] != null ? map['cncStaff'] as String : null,
      cncStaffConfirmDate: map['cncStaffConfirmDate'] != null ? DateTime.parse(map['cncStaffConfirmDate']) : null,
      cncStaffComment: map['cncStaffComment'] != null ? map['cncStaffComment'] as String : null,
      status: map['status'] as int,
      isDelete: map['isDelete'] as bool,
      isActive: map['isActive'] as bool,
      userCreate: map['userCreate'] != null ? map['userCreate'] as String : null,
      userUpdate: map['userUpdate'] != null ? map['userUpdate'] as String : null,
      dateCreate: map['dateCreate'] != null ? DateTime.parse(map['dateCreate']) : null,
      dateUpdate: map['dateUpdate'] != null ? DateTime.parse(map['dateUpdate']) : null,
      sortIndex: map['sortIndex'] as int,
      totalDetail: map['totalDetail'] as int,
      system: SystemModel.fromJson(map['system']),
      statusInfo: VariableModel.fromJson(map['statusInfo']),
    );
  }
}
