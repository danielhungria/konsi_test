import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/address.dart';


abstract class NotebookLocalDataSource {
  List<Address> getAddresses();
  Future<void> addAddress(Address address);
  Future<void> deleteAddress(Address address);
}

class NotebookLocalDataSourceImpl implements NotebookLocalDataSource {
  final box = Hive.box<Address>('addressBox');

  static Future<void> init() async {
    await Hive.openBox<Address>('addressBox');
  }

  @override
  Future<void> addAddress(Address address) {
    return box.add(address);
  }

  @override
  Future<void> deleteAddress(Address address) async {
    box.delete(address.key);
  }

  @override
  List<Address> getAddresses() {
    return List<Address>.from(box.values);
  }

}
