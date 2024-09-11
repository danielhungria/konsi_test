

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:konsi_test/core/services/geocoding_service.dart';
import 'package:konsi_test/src/map/presentation/bloc/map_bloc.dart';
import 'package:konsi_test/src/notebook/domain/usecases/add_address.dart';
import 'package:konsi_test/src/notebook/presentation/bloc/notebook_bloc.dart';

import '../../src/home/presentation/bloc/navigation_bloc.dart';
import '../../src/map/data/datasources/cep_local_datasource.dart';
import '../../src/map/data/datasources/cep_remote_datasource.dart';
import '../../src/map/data/repos/cep_repository_impl.dart';
import '../../src/map/domain/entities/cep.dart';
import '../../src/map/domain/repos/cep_repository.dart';
import '../../src/map/domain/usecases/add_history.dart';
import '../../src/map/domain/usecases/fetch_cep.dart';
import 'package:http/http.dart' as http;

import '../../src/map/domain/usecases/get_history.dart';
import '../../src/notebook/data/datasources/notebook_local_datasource.dart';
import '../../src/notebook/data/repos/notebook_repository_impl.dart';
import '../../src/notebook/domain/entities/address.dart';
import '../../src/notebook/domain/repos/notebook_repository.dart';
import '../../src/notebook/domain/usecases/get_addresses.dart';
import '../../src/notebook/domain/usecases/remove_address.dart';

part 'injection_container.main.dart';
