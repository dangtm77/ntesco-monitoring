import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';

class PhieuDeXuatModels {
  final int totalCount;
  final List<PhieuDeXuatModel> data;
  PhieuDeXuatModels({
    required this.totalCount,
    required this.data,
  });
  factory PhieuDeXuatModels.fromJson(dynamic json) {
    return PhieuDeXuatModels(
        totalCount: json['totalCount'],
        data: json['data'].map<PhieuDeXuatModel>((json) {
          return PhieuDeXuatModel.fromJson(json);
        }).toList());
  }
}

class PhieuDeXuatModel {
  final int id;
  final String tieuDe;
  final int idDanhMuc;
  final String tenDanhMuc;
  final DateTime ngayTao;
  final String nguoiTao;
  final NguoiDungModel nguoiTaoInfo;
  final int tinhTrang;
  final bool isQuanTrong;
  final DateTime tuNgay;
  final DateTime denNgay;
  final int isDenLuot;

  PhieuDeXuatModel({
    required this.id,
    required this.tieuDe,
    required this.idDanhMuc,
    required this.tenDanhMuc,
    required this.ngayTao,
    required this.nguoiTao,
    required this.nguoiTaoInfo,
    required this.tinhTrang,
    required this.isQuanTrong,
    required this.tuNgay,
    required this.denNgay,
    required this.isDenLuot,
  });

  factory PhieuDeXuatModel.fromJson(dynamic json) {
    return PhieuDeXuatModel(
      id: json['id'],
      tieuDe: json['tieuDe'],
      idDanhMuc: json['idDanhMuc'],
      tenDanhMuc: json['tenDanhMuc'],
      ngayTao: DateTime.parse((json['ngayTao'])),
      nguoiTao: json['nguoiTao'],
      nguoiTaoInfo: NguoiDungModel.fromJson(json['nguoiTaoInfo']),
      tinhTrang: json['tinhTrang'],
      isQuanTrong: json['isQuanTrong'],
      isDenLuot: json['isDenLuot'],
      tuNgay: DateTime.parse((json['tuNgay'])),
      denNgay: DateTime.parse((json['denNgay'])),
    );
  }
}
