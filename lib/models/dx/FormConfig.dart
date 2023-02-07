// ignore_for_file: public_member_api_docs, sort_constructors_first
class FormConfigModel {
  final int id;
  final String tieuDeLabel;
  final String mucDichLabel;
  final String noiDungLabel;
  final String tuNgayLabel;
  final String denNgayLabel;
  final String giaTriLabel;
  final String giaTri001Label;
  final String giaTri002Label;
  final String optionValue001Label;
  final String optionValue002Label;
  final String optionValue003Label;
  final String optionValue004Label;
  final String optionValue005Label;
  final String optionValue006Label;
  FormConfigModel({
    required this.id,
    required this.tieuDeLabel,
    required this.mucDichLabel,
    required this.noiDungLabel,
    required this.tuNgayLabel,
    required this.denNgayLabel,
    required this.giaTriLabel,
    required this.giaTri001Label,
    required this.giaTri002Label,
    required this.optionValue001Label,
    required this.optionValue002Label,
    required this.optionValue003Label,
    required this.optionValue004Label,
    required this.optionValue005Label,
    required this.optionValue006Label,
  });

  factory FormConfigModel.fromJson(dynamic json) {
    return FormConfigModel(
      id: json['id'],
      tieuDeLabel: json['tieuDeLabel'],
      mucDichLabel: json['mucDichLabel'],
      noiDungLabel: json['noiDungLabel'],
      tuNgayLabel: json['tuNgayLabel'],
      denNgayLabel: json['denNgayLabel'],
      giaTriLabel: json['giaTriLabel'],
      giaTri001Label: json['giaTri001Label'],
      giaTri002Label: json['giaTri002Label'],
      optionValue001Label: json['optionValue001Label'],
      optionValue002Label: json['optionValue002Label'],
      optionValue003Label: json['optionValue003Label'],
      optionValue004Label: json['optionValue004Label'],
      optionValue005Label: json['optionValue005Label'],
      optionValue006Label: json['optionValue006Label'],
    );
  }

  @override
  String toString() {
    return 'FormConfigModel(id: $id, tieuDeLabel: $tieuDeLabel, mucDichLabel: $mucDichLabel, noiDungLabel: $noiDungLabel, tuNgayLabel: $tuNgayLabel, denNgayLabel: $denNgayLabel, giaTriLabel: $giaTriLabel, giaTri001Label: $giaTri001Label, giaTri002Label: $giaTri002Label, optionValue001Label: $optionValue001Label, optionValue002Label: $optionValue002Label, optionValue003Label: $optionValue003Label, optionValue004Label: $optionValue004Label, optionValue005Label: $optionValue005Label, optionValue006Label: $optionValue006Label)';
  }
}
