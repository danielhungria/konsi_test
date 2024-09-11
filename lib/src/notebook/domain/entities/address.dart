import 'package:hive/hive.dart';

part 'address.g.dart';

@HiveType(typeId: 1)
class Address extends HiveObject {
  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String street;

  @HiveField(2)
  final String number;

  @HiveField(3)
  final String complement;

  Address({
    required this.cep,
    required this.street,
    required this.number,
    required this.complement,
  });
}
