// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      }).toList(),
    );
  }
}

class DefectAnalysisModel {
  final int id;
  final int idSystem;
  final String code;
  final DateTime? analysisDate;
  final String? analysisBy;
  // final UserModel? analysisByInfo;
  // final String? currentSuitation;
  // final String? maintenanceStaff;
  // final DateTime? maintenanceStaffConfirmDate;
  // final String? maintenanceStaffComment;
  // final String? qcStaff;
  // final DateTime? qcStaffConfirmDate;
  // final String? qcStaffComment;
  // final String? cncStaff;
  // final DateTime? cncStaffConfirmDate;
  // final String? cncStaffComment;
  final int status;
  final VariableModel statusInfo;
  // final bool isDelete;
  // final bool isActive;
  // final String? userCreate;
  // final String? userUpdate;
  // final DateTime? dateCreate;
  // final DateTime? dateUpdate;
  // final int sortIndex;
  final int totalDetail;
  final String processConfirm;
  final SystemModel system;
  // final ProjectModel project;
  DefectAnalysisModel({
    required this.id,
    required this.idSystem,
    required this.code,
    this.analysisDate,
    this.analysisBy,
    /*this.analysisByInfo, this.currentSuitation, this.maintenanceStaff, this.maintenanceStaffConfirmDate, this.maintenanceStaffComment, this.qcStaff, this.qcStaffConfirmDate, this.qcStaffComment, this.cncStaff, this.cncStaffConfirmDate, this.cncStaffComment */
    required this.status,
    required this.statusInfo,
    /*required this.isDelete, required this.isActive, this.userCreate, this.userUpdate, this.dateCreate, this.dateUpdate, required this.sortIndex*/
    required this.totalDetail,
    required this.processConfirm,
    required this.system,
    /*required this.project*/
  });

  factory DefectAnalysisModel.fromJson(dynamic json) {
    return DefectAnalysisModel(
      id: json['id'] as int,
      idSystem: json['idSystem'] as int,
      code: json['code'] as String,
      analysisDate: json['analysisDate'] != null ? DateTime.parse(json['analysisDate']) : null,
      analysisBy: json['analysisBy'] != null ? json['analysisBy'] as String : null,
      // analysisByInfo: json['analysisByInfo'] != null ? UserModel.fromJson(json['analysisByInfo']) : null,
      // currentSuitation: json['currentSuitation'] != null ? json['currentSuitation'] as String : null,
      // maintenanceStaff: json['maintenanceStaff'] != null ? json['maintenanceStaff'] as String : null,
      // maintenanceStaffConfirmDate: json['maintenanceStaffConfirmDate'] != null ? DateTime.parse(json['maintenanceStaffConfirmDate']) : null,
      // maintenanceStaffComment: json['maintenanceStaffComment'] != null ? json['maintenanceStaffComment'] as String : null,
      // qcStaff: json['qcStaff'] != null ? json['qcStaff'] as String : null,
      // qcStaffConfirmDate: json['qcStaffConfirmDate'] != null ? DateTime.parse(json['qcStaffConfirmDate']) : null,
      // qcStaffComment: json['qcStaffComment'] != null ? json['qcStaffComment'] as String : null,
      // cncStaff: json['cncStaff'] != null ? json['cncStaff'] as String : null,
      // cncStaffConfirmDate: json['cncStaffConfirmDate'] != null ? DateTime.parse(json['cncStaffConfirmDate']) : null,
      // cncStaffComment: json['cncStaffComment'] != null ? json['cncStaffComment'] as String : null,
      status: json['status'] as int,
      statusInfo: VariableModel.fromJson(json['statusInfo']),
      // isDelete: json['isDelete'] as bool,
      // isActive: json['isActive'] as bool,
      // userCreate: json['userCreate'] != null ? json['userCreate'] as String : null,
      // userUpdate: json['userUpdate'] != null ? json['userUpdate'] as String : null,
      // dateCreate: json['dateCreate'] != null ? DateTime.parse(json['dateCreate']) : null,
      // dateUpdate: json['dateUpdate'] != null ? DateTime.parse(json['dateUpdate']) : null,
      // sortIndex: json['sortIndex'] as int,
      totalDetail: json['totalDetail'] as int,
      processConfirm: json['processConfirm'] as String,
      system: SystemModel.fromJson(json['system']),
      //project: ProjectModel.fromJson(json['project']),
    );
  }
}
