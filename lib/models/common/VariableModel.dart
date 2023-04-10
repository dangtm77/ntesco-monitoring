// ignore_for_file: public_member_api_docs, sort_constructors_first

class VariableModels {
  final int totalCount;
  final List<VariableModel> data;
  VariableModels({
    required this.totalCount,
    required this.data,
  });
  factory VariableModels.fromJson(dynamic json) {
    return VariableModels(
        totalCount: json['totalCount'],
        data: json['data'].map<VariableModel>((json) {
          return VariableModel.fromJson(json);
        }).toList());
  }
}

class VariableModel {
  int id;
  //String? group;
  //String? code;
  int? value;
  String? text;
  //String? icon;
  //String? css;
  //String? description;
  //String? option01;
  //String? option02;
  VariableModel({
    required this.id,
    //this.group,
    //this.code,
    required this.value,
    this.text,
    // this.icon,
    // this.css,
    // this.description,
    // this.option01,
    // this.option02,
  });
  factory VariableModel.fromJson(dynamic map) {
    return VariableModel(
      id: map['id'] as int,
      // group: map['group'] != null ? map['group'] as String : null,
      // code: map['code'] != null ? map['code'] as String : null,
      value: map['value'],
      text: map['text'] != null ? map['text'] as String : null,
      // icon: map['icon'] != null ? map['icon'] as String : null,
      // css: map['css'] != null ? map['css'] as String : null,
      // description: map['description'] != null ? map['description'] as String : null,
      // option01: map['option01'] != null ? map['option01'] as String : null,
      // option02: map['option02'] != null ? map['option02'] as String : null,
    );
  }
}
