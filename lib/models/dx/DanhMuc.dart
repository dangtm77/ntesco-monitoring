import 'dart:convert';

class DanhMucModels {
  final int totalCount;
  final List<DanhMucModel> data;
  DanhMucModels({
    required this.totalCount,
    required this.data,
  });
  factory DanhMucModels.fromJson(dynamic json) {
    return DanhMucModels(
        totalCount: json['totalCount'],
        data: json['data'].map<DanhMucModel>((json) {
          return DanhMucModel.fromJson(json);
        }).toList());
  }
}

class DanhMucModel {
  final int id;
  final String tieuDe;
  final String moTa;
  final String nhomDanhMuc;
  final int sapXep;
  DanhMucModel({
    required this.id,
    required this.tieuDe,
    required this.moTa,
    required this.nhomDanhMuc,
    required this.sapXep,
  });
  factory DanhMucModel.fromJson(dynamic json) {
    return DanhMucModel(
      id: json['id'],
      tieuDe: json['tieuDe'],
      moTa: json['moTa'],
      nhomDanhMuc: json['nhomDanhMuc'],
      sapXep: json['sapXep'],
    );
  }
}
