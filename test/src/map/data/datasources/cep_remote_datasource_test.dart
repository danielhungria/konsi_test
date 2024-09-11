import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:konsi_test/core/errors/exceptions.dart';
import 'package:konsi_test/core/utils/constants.dart';
import 'package:konsi_test/src/map/data/datasources/cep_remote_datasource.dart';
import 'package:konsi_test/src/map/data/models/cep_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late CepRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = CepRemoteDataSourceImpl(client: mockHttpClient);
  });

  const tCep = '01001000';
  final tCepModel = CepModel(
    cep: '01001-000',
    bairro: 'Praça da Sé',
    logradouro: 'lado ímpar',
    localidade: 'Sé',
    estado: 'SP',
    ddd: '11',
    uf: 'SP',
  );

  group('', () {
    test('should return CepModel when the response code is 200', () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL$tCep/json/')))
          .thenAnswer((_) async => http.Response(jsonEncode(tCepModel.toJson()), 200));
      // act
      final result = await dataSource.fetchCep(tCep);
      // assert
      expect(result, tCepModel);
    });

    test('should throw a ServerException when the response code is not 200', () async {
      // arrange
      when(() => mockHttpClient.get(Uri.parse('$BASE_URL$tCep/json/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.fetchCep;
      // assert
      expect(() => call(tCep), throwsA(isA<ServerException>()));
    });
  });
}
