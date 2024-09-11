import 'package:konsi_test/src/notebook/domain/entities/address.dart';

import '../../../../core/utils/typdefs.dart';

abstract class NotebookRepository {
  Result<List<Address>> getAddresses();

  ResultFuture addAddress(Address address);

  ResultFuture removeAddress(Address address);
}
