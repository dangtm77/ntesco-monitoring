import 'dart:convert';
  
class NguoiDungModel { 
  //String? username;
  String? anhDaiDien;
  String? hoTen;
  //String? ngaySinh;
  //String? gioiTinh;
  //String? email;
  //String? idNoiCongTac;
  //String? idPhongBan;
  //String? idChucDanh;
  //String? noiCongTac;
  //String? phongBan;
  //String? chucDanh; 

  NguoiDungModel(
      { 
      //this.username,
      this.anhDaiDien,
      this.hoTen,
      // this.ngaySinh,
      // this.gioiTinh,
      // this.email,
      // this.idNoiCongTac,
      // this.idPhongBan,
      // this.idChucDanh,
      // this.noiCongTac,
      // this.phongBan,
      // this.chucDanh 
      });

  factory NguoiDungModel.fromJson(Map<String, dynamic> json) {
    return NguoiDungModel( 
      //username: json["userName"] != null ? json["userName"] : "",
      anhDaiDien: json["anhDaiDien"] != null ? json["anhDaiDien"] : "",
      hoTen: json["hoTen"] != null ? json["hoTen"] : "",
      // ngaySinh: json["ngaySinh"] != null ? json["ngaySinh"] : "",
      // gioiTinh: json["gioiTinh"] != null ? json["gioiTinh"] : "",
      // email: json["email"] != null ? json["email"] : "",
      // idNoiCongTac: json["idNoiCongTac"] != null ? json["idNoiCongTac"] : "",
      // idPhongBan: json["idPhongBan"] != null ? json["idPhongBan"] : "",
      // idChucDanh: json["idChucDanh"] != null ? json["idChucDanh"] : "",
      // noiCongTac: json["noiCongTac"] != null ? json["noiCongTac"] : "",
      // phongBan: json["phongBan"] != null ? json["phongBan"] : "",
      // chucDanh: json["chucDanh"] != null ? json["chucDanh"] : "", 
    );
  }

  Map<String, dynamic> toMap() {
    return { 
      //'userName': username,
      'anhDaiDien':anhDaiDien, 
      'hoTen': hoTen,
      // 'ngaySinh': ngaySinh,
      // 'email': email,
      // 'gioiTinh': gioiTinh,
      // 'idNoiCongTac': idNoiCongTac,
      // 'idPhongBan': idPhongBan,
      // 'idChucDanh': idChucDanh,
      // 'noiCongTac': noiCongTac,
      // 'phongBan': phongBan,
      // 'chucDanh': chucDanh, 
    };
  }

  String toJson() => json.encode(toMap());
}
