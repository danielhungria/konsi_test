import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/cep_model.dart';

abstract class CepRemoteDataSource {
  Future<CepModel> fetchCep(String cep);
}

class CepRemoteDataSourceImpl implements CepRemoteDataSource {
  final http.Client client;

  CepRemoteDataSourceImpl({required this.client});

  @override
  Future<CepModel> fetchCep(String cep) async {
    final url = Uri.parse('$BASE_URL$cep/json/');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['erro'] != null) {
        throw ServerException(
          message: 'CEP not found',
          statusCode: response.statusCode.toString(),
        );
      }

      return CepModel.fromJson(jsonResponse);
    } else {
      throw ServerException(
        message: 'Server Error',
        statusCode: response.statusCode.toString(),
      );
    }
  }
}
