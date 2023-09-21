// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserModels {
  final int totalCount;
  final List<UserModel> data;
  UserModels({required this.totalCount, required this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalCount': totalCount,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      totalCount: map['totalCount'] as int,
      data: List<UserModel>.from(map['data'].map<UserModel>((x) => UserModel.fromMap(x as Map<String, dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModels.fromJson(String source) => UserModels.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserModel {
  final String? msnv;
  final String username;
  final String anhDaiDien;
  final String hoTen;
  UserModel({this.msnv, required this.username, required this.anhDaiDien, required this.hoTen});

  UserModel copyWith({String? msnv, String? username, String? anhDaiDien, String? hoTen}) {
    return UserModel(msnv: msnv ?? this.msnv, username: username ?? this.username, anhDaiDien: anhDaiDien ?? this.anhDaiDien, hoTen: hoTen ?? this.hoTen);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msnv': msnv,
      'username': username,
      'anhDaiDien': anhDaiDien,
      'hoTen': hoTen,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      msnv: map['msnv'] != null ? map['msnv'] as String : null,
      username: map['username'] as String,
      anhDaiDien: map['anhDaiDien'] as String,
      hoTen: map['hoTen'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
