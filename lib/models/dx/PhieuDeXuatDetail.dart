// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ntesco_smart_monitoring/models/NguoiDung.dart';
import 'package:ntesco_smart_monitoring/models/dx/FormConfig.dart';

class PhieuDeXuatDetailModel {
  final int id;
  final int idDanhMuc;
  final String tenDanhMuc;
  final String tieuDe;
  final String noiDung;
  final String mucDich;
  final DateTime ngayTao;
  final String nguoiTao;
  final NguoiDungModel nguoiTaoInfo;
  final int tinhTrang;
  final bool isQuanTrong;
  final DateTime tuNgay;
  final DateTime denNgay;
  final int isDenLuot;
  final double giaTri;
  final double giaTri001;
  final double giaTri002;
  final String optionValue001;
  final String optionValue002;
  final String optionValue003;
  final String optionValue004;
  final String optionValue005;
  final String optionValue006;
  final FormConfigModel formConfig;
  PhieuDeXuatDetailModel({
    required this.id,
    required this.idDanhMuc,
    required this.tenDanhMuc,
    required this.tieuDe,
    required this.noiDung,
    required this.mucDich,
    required this.ngayTao,
    required this.nguoiTao,
    required this.nguoiTaoInfo,
    required this.tinhTrang,
    required this.isQuanTrong,
    required this.tuNgay,
    required this.denNgay,
    required this.isDenLuot,
    required this.giaTri,
    required this.giaTri001,
    required this.giaTri002,
    required this.optionValue001,
    required this.optionValue002,
    required this.optionValue003,
    required this.optionValue004,
    required this.optionValue005,
    required this.optionValue006,
    required this.formConfig,
  });

  factory PhieuDeXuatDetailModel.fromJson(dynamic json) {
    return PhieuDeXuatDetailModel(
      id: json['id'],
      tieuDe: json['tieuDe'],
      noiDung: json['noiDung'],
      mucDich: json['mucDich'],
      idDanhMuc: json['idDanhMuc'],
      tenDanhMuc: json['tenDanhMuc'],
      ngayTao: DateTime.parse((json['ngayTao'])),
      nguoiTao: json['nguoiTao'],
      nguoiTaoInfo: NguoiDungModel.fromJson(json['nguoiTaoInfo']),
      tinhTrang: json['tinhTrang'],
      isQuanTrong: json['isQuanTrong'],
      tuNgay: DateTime.parse((json['tuNgay'])),
      denNgay: DateTime.parse((json['denNgay'])),
      isDenLuot: json['isDenLuot'],
      giaTri: json['giaTri'],
      giaTri001: json['giaTri001'],
      giaTri002: json['giaTri002'],
      optionValue001: json['optionValue001'],
      optionValue002: json['optionValue002'],
      optionValue003: json['optionValue003'],
      optionValue004: json['optionValue004'],
      optionValue005: json['optionValue005'],
      optionValue006: json['optionValue006'],
      formConfig: FormConfigModel.fromJson(json['formConfig']),
    );
  }
}
