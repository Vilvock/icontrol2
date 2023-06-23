
import 'global_ws_model.dart';

class Equipment extends GlobalWSModel{
  final String url;
  final String nome;
  final int marca;
  final String marca_nome;
  final int modelo;
  final String modelo_nome;
  final int ano;
  final String serie;
  final String horimetro;
  final String proprietario;
  final String tag;
  final String data_cadastro;


  Equipment({
    required this.url,
    required this.nome,
    required this.marca,
    required this.marca_nome,
    required this.modelo,
    required this.modelo_nome,
    required this.ano,
    required this.serie,
    required this.horimetro,
    required this.proprietario,
    required this.tag,
    required this.data_cadastro, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      url: json['url'],
      nome: json['nome'],
      marca: json['marca'],
      marca_nome: json['marca_nome'],
      modelo: json['modelo'],
      modelo_nome: json['modelo_nome'],
      ano: json['ano'],
      serie: json['serie'],
      horimetro: json['horimetro'],
      proprietario: json['proprietario'],
      tag: json['tag'],
      data_cadastro: json['data_cadastro'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

}