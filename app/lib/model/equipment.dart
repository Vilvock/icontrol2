
import 'global_ws_model.dart';

class Equipment extends GlobalWSModel{
  final String url;

  Equipment({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}