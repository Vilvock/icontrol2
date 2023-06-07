
import 'global_ws_model.dart';

class Fleet extends GlobalWSModel{
  final String url;

  Fleet({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Fleet.fromJson(Map<String, dynamic> json) {
    return Fleet(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}