
import '../global_ws_model.dart';

class TaskEmployee extends GlobalWSModel{
  final String url;

  TaskEmployee({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory TaskEmployee.fromJson(Map<String, dynamic> json) {
    return TaskEmployee(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}