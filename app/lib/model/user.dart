
import 'global_ws_model.dart';

class User extends GlobalWSModel{
  final String nome;
  final String email;
  final String documento;
  final String celular;
  final String avatar;
  final String cep;
  final String uf;
  final String cidade;
  final String estado;
  final String endereco;
  final String bairro;
  final String numero;
  final String complemento;
  final dynamic latitude;
  final dynamic longitude;
  final String endereco_completo;
  final String descricao;
  final String data;
  final String titulo;
  final String logradouro;
  final String localidade;
  final String tipo_pessoa;
  final int saldo_aprovado;
  final String type;

  User({
    required this.nome,
    required this.email,
    required this.documento,
    required this.celular,
    required this.avatar,
    required this.cep,
    required this.uf,
    required this.estado,
    required this.cidade,
    required this.endereco,
    required this.bairro,
    required this.numero,
    required this.complemento,
    required this.latitude,
    required this.longitude,
    required this.endereco_completo,
    required this.descricao,
    required this.data,
    required this.titulo,
    required this.logradouro,
    required this.localidade,
    required this.tipo_pessoa,
    required this.saldo_aprovado,
    required this.type, required super.status, required super.msg, required super.id, required super.rows,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nome: json['nome'],
      email: json['email'],
      documento: json['documento'],
      celular: json['celular'],
      avatar: json['avatar'],
      cep: json['cep'],
      uf: json['uf'],
      estado: json['estado'],
      cidade: json['cidade'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      numero: json['numero'],
      complemento: json['complemento'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      endereco_completo: json['endereco_completo'],
      descricao: json['descricao'],
      data: json['data'],
      titulo: json['titulo'],
      localidade: json['localidade'],
      logradouro: json['logradouro'],
      tipo_pessoa: json['tipo_pessoa'],
      saldo_aprovado: json['saldo_aprovado'],
      type: json['type'],
      status: json['status'],
      msg: json['msg'],
      id: json['id'],
      rows: json['rows'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'documento': documento,
      'celular': celular,
      'avatar': avatar,
      'status': status,
      'msg': msg,
      'id': id,
      'rows': rows,
    };
  }
}