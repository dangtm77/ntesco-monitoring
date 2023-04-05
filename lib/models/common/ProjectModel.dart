// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProjectModels {
  final int totalCount;
  final List<ProjectModel> data;
  ProjectModels({
    required this.totalCount,
    required this.data,
  });
  factory ProjectModels.fromJson(dynamic json) {
    return ProjectModels(
        totalCount: json['totalCount'],
        data: json['data'].map<ProjectModel>((json) {
          return ProjectModel.fromJson(json);
        }).toList());
  }
}

class ProjectModel {
  int id;
  String? code;
  String? contractNo;
  String? name;
  String? otherName;
  String? location;
  String? customer;
  String? contactPerson001;
  String? contactPerson002;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? dateAcceptance;
  ProjectModel({
    required this.id,
    this.code,
    this.contractNo,
    this.name,
    this.otherName,
    this.location,
    this.customer,
    this.contactPerson001,
    this.contactPerson002,
    this.startDate,
    this.endDate,
    this.dateAcceptance,
  });

  factory ProjectModel.fromJson(dynamic map) {
    return ProjectModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      contractNo: map['contractNo'] != null ? map['contractNo'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      otherName: map['otherName'] != null ? map['otherName'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      customer: map['customer'] != null ? map['customer'] as String : null,
      contactPerson001: map['contactPerson001'] != null ? map['contactPerson001'] as String : null,
      contactPerson002: map['contactPerson002'] != null ? map['contactPerson002'] as String : null,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      dateAcceptance: map['dateAcceptance'] != null ? DateTime.parse(map['dateAcceptance']) : null,
    );
  }
}
