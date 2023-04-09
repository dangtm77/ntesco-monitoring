// ignore_for_file: public_member_api_docs, sort_constructors_first
class FileDinhKemModels {
  final int totalCount;
  final List<FileDinhKemModel> data;
  FileDinhKemModels({
    required this.totalCount,
    required this.data,
  });
  factory FileDinhKemModels.fromJson(dynamic json) {
    return FileDinhKemModels(
        totalCount: json['totalCount'],
        data: json['data'].map<FileDinhKemModel>((json) {
          return FileDinhKemModel.fromJson(json);
        }).toList());
  }
}

class FileDinhKemModel {
  final int id;
  final String displayName;
  final String pathFile;
  final String typeFile;
  final String userCreate;
  final DateTime dateCreate;
  final String type;
  final int idOfType;
  FileDinhKemModel({required this.id, required this.displayName, required this.pathFile, required this.typeFile, required this.userCreate, required this.dateCreate, required this.type, required this.idOfType});
  factory FileDinhKemModel.fromJson(dynamic map) {
    return FileDinhKemModel(
      id: map['id'] as int,
      displayName: map['displayName'] as String,
      pathFile: map['pathFile'] as String,
      typeFile: map['typeFile'] as String,
      userCreate: map['userCreate'] as String,
      dateCreate: DateTime.parse(map['dateCreate']),
      type: map['type'] as String,
      idOfType: map['idOfType'] as int,
    );
  }

  @override
  String toString() {
    return 'FileDinhKemModel(id: $id, displayName: $displayName, pathFile: $pathFile, typeFile: $typeFile, userCreate: $userCreate, dateCreate: $dateCreate, type: $type, idOfType: $idOfType)';
  }
}
