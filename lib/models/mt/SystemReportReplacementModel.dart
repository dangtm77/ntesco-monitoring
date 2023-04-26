class SystemReportReplacementModels {
  final int totalCount;
  final List<SystemReportReplacementModel> data;
  SystemReportReplacementModels({
    required this.totalCount,
    required this.data,
  });
  factory SystemReportReplacementModels.fromJson(dynamic json) {
    return SystemReportReplacementModels(
      totalCount: json['totalCount'] as int,
      data: json['data'].map<SystemReportReplacementModel>((json) => SystemReportReplacementModel.fromJson(json)).toList(),
    );
  }
}

class SystemReportReplacementModel {
  final int id;
  final int? idSystemReport;
  final String? code;
  final String? name;
  final String? model;
  final String? unit;
  final double? quantity;
  final bool? stateOfEmergency;
  final String? specifications;
  SystemReportReplacementModel({required this.id, this.idSystemReport, this.code, this.name, this.model, this.unit, this.quantity, this.stateOfEmergency, this.specifications});

  factory SystemReportReplacementModel.fromJson(dynamic json) {
    return SystemReportReplacementModel(
      id: json['id'] as int,
      idSystemReport: json['idSystemReport'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      unit: json['unit'] as String,
      quantity: json['quantity'] as double,
      stateOfEmergency: json['stateOfEmergency'] as bool,
      specifications: json['specifications'] as String,
    );
  }
}
