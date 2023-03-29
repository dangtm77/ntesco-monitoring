// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  ProjectModel({
    required this.id,
    this.code,
    this.contractNo,
    this.name,
    this.otherName,
    this.location,
    this.customer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'contractNo': contractNo,
      'name': name,
      'otherName': otherName,
      'location': location,
      'customer': customer,
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      contractNo: map['contractNo'] != null ? map['contractNo'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      otherName: map['otherName'] != null ? map['otherName'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      customer: map['customer'] != null ? map['customer'] as String : null,
    );
  }
}
