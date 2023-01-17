import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';

class PhieuDeXuatListModels {
  final int totalCount;
  final List<PhieuDeXuatListModel> data;
  PhieuDeXuatListModels({
    required this.totalCount,
    required this.data,
  });
  factory PhieuDeXuatListModels.fromJson(dynamic json) {
    return PhieuDeXuatListModels(
        totalCount: json['totalCount'],
        data: json['data'].map<PhieuDeXuatListModel>((json) {
          return PhieuDeXuatListModel.fromJson(json);
        }).toList());
  }
}

class PhieuDeXuatListModel {
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
  final String tienDo;

  PhieuDeXuatListModel({
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
    required this.tienDo,
  });

  factory PhieuDeXuatListModel.fromJson(dynamic json) {
    return PhieuDeXuatListModel(
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
      tienDo: json['tienDo'],
    );
  }
}
