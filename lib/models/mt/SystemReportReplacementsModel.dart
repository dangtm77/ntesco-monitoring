// ignore_for_file: public_member_api_docs, sort_constructors_first
class SystemReportReplacementsModels {
  final int totalCount;
  final List<SystemReportReplacementsModel> data;
  SystemReportReplacementsModels({
    required this.totalCount,
    required this.data,
  });
  factory SystemReportReplacementsModels.fromJson(dynamic json) {
    return SystemReportReplacementsModels(
      totalCount: json['totalCount'] as int,
      data: json['data'].map<SystemReportReplacementsModel>((json) => SystemReportReplacementsModel.fromJson(json)).toList(),
    );
  }
}

class SystemReportReplacementsModel {
  final int id;
  final int? idSystemReport;
  final String? code;
  final String? name;
  final String? model;
  final String? unit;
  final double? quantity;
  final bool? stateOfEmergency;
  final String? specifications;
  final int sortIndex;
  SystemReportReplacementsModel({
    required this.id,
    this.idSystemReport,
    this.code,
    this.name,
    this.model,
    this.unit,
    this.quantity,
    this.stateOfEmergency,
    this.specifications,
    required this.sortIndex,
  });

  factory SystemReportReplacementsModel.fromJson(dynamic json) {
    return SystemReportReplacementsModel(
      id: json['id'] as int,
      idSystemReport: json['idSystemReport'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      unit: json['unit'] as String,
      quantity: json['quantity'] as double,
      stateOfEmergency: json['stateOfEmergency'] as bool,
      specifications: json['specifications'] as String,
      sortIndex: json['sortIndex'] as int,
    );
  }
}
