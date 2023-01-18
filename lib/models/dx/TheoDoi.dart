// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';

class TheoDoiModels {
  final int totalCount;
  final List<TheoDoiModel> data;
  TheoDoiModels({
    required this.totalCount,
    required this.data,
  });
  factory TheoDoiModels.fromJson(dynamic json) {
    return TheoDoiModels(
        totalCount: json['totalCount'],
        data: json['data'].map<TheoDoiModel>((json) {
          return TheoDoiModel.fromJson(json);
        }).toList());
  }
}

class TheoDoiModel {
  final int id;
  final int idPhieuDeXuat;
  final String nguoiDuyet;
  final NguoiDungModel nguoiDuyetInfo;
  final bool? isDuyet;
  final String ghiChu;
  final int thuTu;
  final DateTime? ngayCapNhat;
  final bool isDenLuot;
  TheoDoiModel({
    required this.id,
    required this.idPhieuDeXuat,
    required this.nguoiDuyet,
    required this.nguoiDuyetInfo,
    this.isDuyet,
    required this.ghiChu,
    required this.thuTu,
    this.ngayCapNhat,
    required this.isDenLuot,
  });

  factory TheoDoiModel.fromJson(dynamic json) {
    return TheoDoiModel(
      id: json['id'],
      idPhieuDeXuat: json['idPhieuDeXuat'],
      nguoiDuyet: json['nguoiDuyet'],
      nguoiDuyetInfo: NguoiDungModel.fromJson(json['nguoiDuyetInfo']),
      isDuyet: json['isDuyet'],
      ghiChu: json['ghiChu'],
      thuTu: json['thuTu'],
      ngayCapNhat: json['ngayCapNhat'] != null ? DateTime.parse(json['ngayCapNhat']) : null,
      isDenLuot: json['isDenLuot'],
    );
  }
}
