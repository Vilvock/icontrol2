
import 'global_ws_model.dart';

class Brand extends GlobalWSModel{
  final String url;

  Brand({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}