class SystemSpecificationModels {
  final int totalCount;
  final List<SystemSpecificationModel> data;
  SystemSpecificationModels({required this.totalCount, required this.data});
  factory SystemSpecificationModels.fromJson(dynamic json) {
    return SystemSpecificationModels(
        totalCount: json['totalCount'] as int,
        data: json['data'].map<SystemSpecificationModel>((json) {
          return SystemSpecificationModel.fromJson(json);
        }).toList());
  }
}

class SystemSpecificationModel {
  final int id;
  final String? title;
  final String? dataType;
  final String? dataValues;
  final String? dataUnit;
  final String? helpText;
  final int? sortIndex;
  SystemSpecificationModel({
    required this.id,
    this.title,
    this.dataType,
    this.dataValues,
    this.dataUnit,
    this.helpText,
    this.sortIndex,
  });

  factory SystemSpecificationModel.fromJson(dynamic map) {
    return SystemSpecificationModel(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      dataType: map['dataType'] != null ? map['dataType'] as String : null,
      dataValues:
          map['dataValues'] != null ? map['dataValues'] as String : null,
      dataUnit: map['dataUnit'] != null ? map['dataUnit'] as String : null,
      helpText: map['helpText'] != null ? map['helpText'] as String : null,
      sortIndex: map['sortIndex'] != null ? map['sortIndex'] as int : null,
    );
  }

  @override
  String toString() {
    return 'SystemSpecificationModel(id: $id, title: $title, dataType: $dataType, dataValues: $dataValues, dataUnit: $dataUnit, helpText: $helpText, sortIndex: $sortIndex)';
  }
}
