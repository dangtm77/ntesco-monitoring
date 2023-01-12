// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ThongKeModels {
  final int totalCount;
  final List<ThongKeModel> data;
  ThongKeModels({
    required this.totalCount,
    required this.data,
  });
  factory ThongKeModels.fromJson(dynamic json) {
    return ThongKeModels(
        totalCount: json['totalCount'],
        data: json['data'].map<ThongKeModel>((json) {
          return ThongKeModel.fromJson(json);
        }).toList());
  }
}

class ThongKeModel {  
  final int khoiTao;
  final int dangXuLy;
  final int daDuyet;
  final int tuChoi;
  final int denLuot;
  final int tongCong;
  ThongKeModel({ 
    required this.khoiTao,
    required this.dangXuLy,
    required this.daDuyet,
    required this.tuChoi,
    required this.denLuot,
    required this.tongCong,
  });
 
factory ThongKeModel.fromJson(dynamic json) {
    return ThongKeModel( 
        khoiTao: json['khoiTao'],
        dangXuLy: json['dangXuLy'],
        daDuyet: json['daDuyet'],
        tuChoi: json['tuChoi'],
        denLuot: json['denLuot'],
        tongCong: json['tongCong']);
  } 
  }
