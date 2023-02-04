import 'dart:convert';

import 'package:ntesco_smart_monitoring/models/dx/FormConfig.dart';

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
  final String loaiQuyTrinh;
  final int sapXep;
  final FormConfigModel formConfig;
  DanhMucModel({
    required this.id,
    required this.tieuDe,
    required this.moTa,
    required this.nhomDanhMuc,
    required this.loaiQuyTrinh,
    required this.sapXep,
    required this.formConfig,
  });
  factory DanhMucModel.fromJson(dynamic json) {
    return DanhMucModel(
      id: json['id'],
      tieuDe: json['tieuDe'],
      moTa: json['moTa'],
      nhomDanhMuc: json['nhomDanhMuc'],
      loaiQuyTrinh: json['loaiQuyTrinh'] == "MotNguoi" ? "Chỉ 1 người duyệt" : (json['loaiQuyTrinh'] == "TuanTu" ? "Duyệt lần lượt" : "Duyệt đồng thời"),
      sapXep: json['sapXep'],
      formConfig: FormConfigModel.fromJson(json['formConfig']),
    );
  }
}
