
import 'global_ws_model.dart';

class Model extends GlobalWSModel{
  final String url;

  Model({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}