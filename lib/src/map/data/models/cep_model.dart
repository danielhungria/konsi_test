
import '../../domain/entities/cep.dart';

class CepModel extends Cep {
  CepModel({
    required super.cep,
    required super.logradouro,
    required super.bairro,
    required super.localidade,
    required super.uf,
    required super.estado,
    required super.ddd,
  });

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] as String,
      logradouro: json['logradouro'] as String,
      bairro: json['bairro'] as String,
      localidade: json['localidade'] as String,
      uf: json['uf'] as String,
      estado: json['estado'] ?? '',
      ddd: json['ddd'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'estado': estado,
      'ddd': ddd,
    };
  }
}
