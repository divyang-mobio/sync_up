class DataModel {
  int? id;
  String data;

  DataModel({this.id, required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        id: json['id'] as int?,
        data: json['data'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'data': data};
}
