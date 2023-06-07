
import 'global_ws_model.dart';

class Employee extends GlobalWSModel{
  final String url;

  Employee({
    required this.url, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      url: json['url'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}