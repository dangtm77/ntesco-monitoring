// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';

class PhieuDeXuatDetailModel {
  final int id;
  final String tieuDe;
  final String tieuDeLabel;
  final String mucDich;
  final String mucDichLabel;
  final String noiDung;
  final String noiDungLabel;
  final int idDanhMuc;
  final String tenDanhMuc;
  final DateTime ngayTao;
  final String nguoiTao;
  final NguoiDungModel nguoiTaoInfo;
  final int tinhTrang;
  final bool isQuanTrong;
  final DateTime tuNgay;
  final String tuNgayLabel;
  final DateTime denNgay;
  final String denNgayLabel;
  final int isDenLuot;
  PhieuDeXuatDetailModel({
    required this.id,
    required this.tieuDe,
    required this.tieuDeLabel,
    required this.mucDich,
    required this.mucDichLabel,
    required this.noiDung,
    required this.noiDungLabel,
    required this.idDanhMuc,
    required this.tenDanhMuc,
    required this.ngayTao,
    required this.nguoiTao,
    required this.nguoiTaoInfo,
    required this.tinhTrang,
    required this.isQuanTrong,
    required this.tuNgay,
    required this.tuNgayLabel,
    required this.denNgay,
    required this.denNgayLabel,
    required this.isDenLuot,
  });

  factory PhieuDeXuatDetailModel.fromJson(dynamic json) {
    return PhieuDeXuatDetailModel(
      id: json['id'],
      tieuDe: json['tieuDe'],
      tieuDeLabel: "Tiêu đề phiếu",
      mucDich: json['mucDich'],
      mucDichLabel: "Lý do và mục đích",
      noiDung: json['noiDung'],
      noiDungLabel: "Nội dung thông tin",
      idDanhMuc: json['idDanhMuc'],
      tenDanhMuc: json['tenDanhMuc'],
      ngayTao: DateTime.parse((json['ngayTao'])),
      nguoiTao: json['nguoiTao'],
      nguoiTaoInfo: NguoiDungModel.fromJson(json['nguoiTaoInfo']),
      tinhTrang: json['tinhTrang'],
      isQuanTrong: json['isQuanTrong'],
      isDenLuot: json['isDenLuot'],
      tuNgay: DateTime.parse((json['tuNgay'])),
      tuNgayLabel: "Thời gian bắt đầu",
      denNgay: DateTime.parse((json['denNgay'])),
      denNgayLabel: "Thời gian kết thúc",
    );
  }
}
