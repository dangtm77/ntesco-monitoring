import 'dart:convert';

class LoginRequestModel {
  String? username;
  String? password;

  LoginRequestModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username,
      'password': password,
      'grant_type': 'password'
    };

    return map;
  }
}

class LoginResponseModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? issued;
  String? expires;
  String? username;
  String? anhDaiDien;
  String? hoTen;
  String? ngaySinh;
  String? gioiTinh;
  String? email;
  String? idNoiCongTac;
  String? idPhongBan;
  String? idChucDanh;
  String? noiCongTac;
  String? phongBan;
  String? chucDanh;

  String? errorDescription;
  String? error;

  LoginResponseModel(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.issued,
      this.expires,
      this.username,
      this.anhDaiDien,
      this.hoTen,
      this.ngaySinh,
      this.gioiTinh,
      this.email,
      this.idNoiCongTac,
      this.idPhongBan,
      this.idChucDanh,
      this.noiCongTac,
      this.phongBan,
      this.chucDanh,
      
      this.errorDescription,
      this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["access_token"] != null ? json["access_token"] : "",
      tokenType: json["token_type"] != null ? json["token_type"] : "",
      expiresIn: json["expires_in"] != null ? json["expires_in"] : 0,
      issued: json[".issued"] != null ? json[".issued"] : "",
      expires: json[".expires"] != null ? json[".expires"] : "",
      username: json["userName"] != null ? json["userName"] : "",
      anhDaiDien: json["anhDaiDien"] != null ? json["anhDaiDien"] : "",
      hoTen: json["hoTen"] != null ? json["hoTen"] : "",
      ngaySinh: json["ngaySinh"] != null ? json["ngaySinh"] : "",
      gioiTinh: json["gioiTinh"] != null ? json["gioiTinh"] : "",
      email: json["email"] != null ? json["email"] : "",
      idNoiCongTac: json["idNoiCongTac"] != null ? json["idNoiCongTac"] : "",
      idPhongBan: json["idPhongBan"] != null ? json["idPhongBan"] : "",
      idChucDanh: json["idChucDanh"] != null ? json["idChucDanh"] : "",
      noiCongTac: json["noiCongTac"] != null ? json["noiCongTac"] : "",
      phongBan: json["phongBan"] != null ? json["phongBan"] : "",
      chucDanh: json["chucDanh"] != null ? json["chucDanh"] : "",

      errorDescription:json["error_description"] != null ? json["error_description"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      '.issued': issued,
      '.expires': expires,
      'userName': username,
      'anhDaiDien':anhDaiDien,

      'hoTen': hoTen,
      'ngaySinh': ngaySinh,
      'email': email,
      'gioiTinh': gioiTinh,
      'idNoiCongTac': idNoiCongTac,
      'idPhongBan': idPhongBan,
      'idChucDanh': idChucDanh,
      'noiCongTac': noiCongTac,
      'phongBan': phongBan,
      'chucDanh': chucDanh,

      'error_description': errorDescription,
      'error': error,
    };
  }

  String toJson() => json.encode(toMap());
}
