class ContactUsModels {
  final int totalCount;
  final List<ContactUsModel> data;
  ContactUsModels({
    required this.totalCount,
    required this.data,
  });
  factory ContactUsModels.fromJson(dynamic json) {
    return ContactUsModels(
        totalCount: json['totalCount'],
        data: json['data'].map<ContactUsModel>((json) {
          return ContactUsModel.fromJson(json);
        }).toList());
  }
}

class ContactUsModel {
  final int id;
  final String title;
  final String value;
  final String? option001; 
  final String? option002; 
  final String? option003; 

  ContactUsModel(
      {required this.id,
      required this.title,
      required this.value,
      this.option001, this.option002, this.option003 });

  factory ContactUsModel.fromJson(dynamic json) {
    return ContactUsModel(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      option001: json['option001'], 
      option002: json['option002'] ,
      option003: json['option003'] 
    );
  }
}
