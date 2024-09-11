import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cep.g.dart';

@HiveType(typeId: 0)
class Cep extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String logradouro;

  @HiveField(2)
  final String bairro;

  @HiveField(3)
  final String localidade;

  @HiveField(4)
  final String uf;

  @HiveField(5)
  final String estado;

  @HiveField(6)
  final String ddd;

  Cep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.estado,
    required this.ddd,
  });

  @override
  List<Object?> get props => [
    cep,
    logradouro,
    bairro,
    localidade,
    uf,
    estado,
    ddd,
  ];
}
