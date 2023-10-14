class SystemModels {
  final int totalCount;
  final List<SystemModel> data;
  SystemModels({required this.totalCount, required this.data});
  factory SystemModels.fromJson(dynamic json) {
    return SystemModels(
        totalCount: json['totalCount'],
        data: json['data'].map<SystemModel>((json) {
          return SystemModel.fromJson(json);
        }).toList());
  }
}

class SystemModel {
  final int id;
  final int idProject;
  final String? code;
  final String? name;
  final String? otherName;
  final DateTime? dateAcceptance;
  SystemModel({
    required this.id,
    required this.idProject,
    this.code,
    this.name,
    this.otherName,
    this.dateAcceptance,
  });
  factory SystemModel.fromJson(dynamic map) {
    print('--');
    print(map['dateAcceptance']);
    print('--');
    return SystemModel(
      id: map['id'] as int,
      idProject: map['idProject'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      otherName: map['otherName'] != null ? map['otherName'] as String : null,
      dateAcceptance: map['dateAcceptance'] != null ? DateTime.parse(map['dateAcceptance']) : null,
    );
  }
}
