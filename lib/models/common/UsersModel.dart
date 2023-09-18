// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UsersModels {
  final int totalCount;
  final List<UsersModel> data;
  UsersModels({
    required this.totalCount,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalCount': totalCount,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory UsersModels.fromMap(Map<String, dynamic> map) {
    return UsersModels(
      totalCount: map['totalCount'] as int,
      data: List<UsersModel>.from(
        map['data'].map<UsersModel>((x) => UsersModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModels.fromJson(String source) => UsersModels.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UsersModel {
  final String? msnv;
  final String username;
  final String? anhDaiDien;
  final String hoTen;
  UsersModel({
    this.msnv,
    required this.username,
    this.anhDaiDien,
    required this.hoTen,
  });

  UsersModel copyWith({
    String? msnv,
    String? username,
    String? anhDaiDien,
    String? hoTen,
  }) {
    return UsersModel(
      msnv: msnv ?? this.msnv,
      username: username ?? this.username,
      anhDaiDien: anhDaiDien ?? this.anhDaiDien,
      hoTen: hoTen ?? this.hoTen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msnv': msnv,
      'username': username,
      'anhDaiDien': anhDaiDien,
      'hoTen': hoTen,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      msnv: map['msnv'] != null ? map['msnv'] as String : null,
      username: map['username'] as String,
      anhDaiDien: map['anhDaiDien'] != null ? map['anhDaiDien'] as String : null,
      hoTen: map['hoTen'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) => UsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsersModel(msnv: $msnv, username: $username, anhDaiDien: $anhDaiDien, hoTen: $hoTen)';
  }

  @override
  bool operator ==(covariant UsersModel other) {
    if (identical(this, other)) return true;

    return other.msnv == msnv && other.username == username && other.anhDaiDien == anhDaiDien && other.hoTen == hoTen;
  }

  @override
  int get hashCode {
    return msnv.hashCode ^ username.hashCode ^ anhDaiDien.hashCode ^ hoTen.hashCode;
  }
}
