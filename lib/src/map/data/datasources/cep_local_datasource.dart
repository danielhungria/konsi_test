import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/cep.dart';

abstract class CepLocalDataSource {
  List<Cep> getHistory();
  Future<void> addCep(Cep cep);
  Future<void> clearHistory();
}

class CepLocalDataSourceImpl implements CepLocalDataSource {
  final box = Hive.box<Cep>('historyBox');

  static Future<void> init() async {
    await Hive.openBox<Cep>('historyBox');
  }

  @override
  Future<void> addCep(Cep cep) async {
    await box.add(cep);
  }

  @override
  Future<void> clearHistory() async {
    await box.clear();
  }

  @override
  List<Cep> getHistory() {
    return List<Cep>.from(box.values);
  }

}
