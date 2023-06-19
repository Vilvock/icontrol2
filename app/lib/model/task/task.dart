
import '../global_ws_model.dart';

class Task extends GlobalWSModel{
  final String url;

  Task({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}