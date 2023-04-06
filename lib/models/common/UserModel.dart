// ignore_for_file: non_constant_identifier_names

class UserModels {
  final int totalCount;
  final List<UserModel> data;
  UserModels({
    required this.totalCount,
    required this.data,
  });
  factory UserModels.fromJson(dynamic json) {
    return UserModels(
        totalCount: json['totalCount'],
        data: json['data'].map<UserModel>((json) {
          return UserModel.fromJson(json);
        }).toList());
  }
}

class UserModel {
  final String username;
  final String? anhDaiDien;
  final String hoTen;
  //String? ngaySinh;
  //String? gioiTinh;
  //String? email;
  final int idTrangThai;
  final int idPhongBan;
  final int idRootPhongBan;
  final int idChucDanh;
  //String? noiCongTac;
  final String rootPhongBan;
  final String phongBan;
  final String chucDanh;

  final int chucDanh_SapXep;
  final int phongBan_SapXep;
  final String chucDanh_Loai;

  UserModel({
    required this.username,
    this.anhDaiDien,
    required this.hoTen,
    // this.ngaySinh,
    // this.gioiTinh,
    // this.email,
    required this.idTrangThai,
    required this.idPhongBan,
    required this.idRootPhongBan,
    required this.idChucDanh,
    required this.rootPhongBan,
    required this.phongBan,
    required this.chucDanh,
    required this.chucDanh_SapXep,
    required this.phongBan_SapXep,
    required this.chucDanh_Loai,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json["username"],
      anhDaiDien: json["anhDaiDien"] != null ? json["anhDaiDien"] : "",
      hoTen: json["hoTen"],
      // ngaySinh: json["ngaySinh"] != null ? json["ngaySinh"] : "",
      // gioiTinh: json["gioiTinh"] != null ? json["gioiTinh"] : "",
      // email: json["email"] != null ? json["email"] : "",
      idTrangThai: json["idTrangThai"] as int,
      idPhongBan: json["idPhongBan"] as int,
      idRootPhongBan: json["idRootPhongBan"] as int,
      idChucDanh: json["idChucDanh"] as int,
      rootPhongBan: json["rootPhongBan"],
      phongBan: json["phongBan"],
      chucDanh: json["chucDanh"],
      chucDanh_SapXep: json["chucDanh_SapXep"] as int,
      phongBan_SapXep: json["phongBan_SapXep"] as int,
      chucDanh_Loai: json["chucDanh_Loai"],
    );
  }
}
