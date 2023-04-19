import 'dart:convert';

class SystemReportsModels {
  final int totalCount;
  final List<SystemReportsModel> data;
  SystemReportsModels({
    required this.totalCount,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalCount': totalCount,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory SystemReportsModels.fromMap(Map<String, dynamic> map) {
    return SystemReportsModels(
      totalCount: map['totalCount'] as int,
      data: List<SystemReportsModel>.from(
        (map['data'] as List<int>).map<SystemReportsModel>(
          (x) => SystemReportsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemReportsModels.fromJson(String source) => SystemReportsModels.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SystemReportsModel {
  final int id;
  final int idSystem;
  final String code;
  final int totalDetail;
  SystemReportsModel({
    required this.id,
    required this.idSystem,
    required this.code,
    required this.totalDetail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idSystem': idSystem,
      'code': code,
      'totalDetail': totalDetail,
    };
  }

  factory SystemReportsModel.fromMap(Map<String, dynamic> map) {
    return SystemReportsModel(
      id: map['id'] as int,
      idSystem: map['idSystem'] as int,
      code: map['code'] as String,
      totalDetail: map['totalDetail'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SystemReportsModel.fromJson(String source) => SystemReportsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SystemReportsModel(id: $id, idSystem: $idSystem, code: $code, totalDetail: $totalDetail)';
  }
}
