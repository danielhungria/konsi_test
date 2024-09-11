import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:konsi_test/core/utils/constants.dart';

import '../../src/map/domain/entities/cep.dart';

class GeocodingService {
  final http.Client client;

  GeocodingService({required this.client});

  static const _baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  Future<LatLng?> getLatLngFromCep(String cep) async {
    final url = '$_baseUrl?address=$cep&key=$API_KEY';
    return _fetchLatLng(url);
  }

  Future<Cep?> getCepFromLatLng(LatLng latLng) async {
    final url = '$_baseUrl?latlng=${latLng.latitude},${latLng.longitude}&key=$API_KEY';
    return _fetchCep(url);
  }

  Future<LatLng?> _fetchLatLng(String url) async {
    final jsonResponse = await _makeRequest(url);
    if (jsonResponse != null && jsonResponse['status'] == 'OK') {
      return _parseLatLng(jsonResponse);
    }
    print('Erro na geocodificação: ${jsonResponse?['status'] ?? 'Desconhecido'}');
    return null;
  }

  Future<Cep?> _fetchCep(String url) async {
    final jsonResponse = await _makeRequest(url);
    if (jsonResponse != null && jsonResponse['status'] == 'OK' && jsonResponse['results'].isNotEmpty) {
      final result = jsonResponse['results'][0];
      return _parseCep(result);
    }
    print('Erro ao obter CEP: ${jsonResponse?['status'] ?? 'Desconhecido'}');
    return null;
  }


  Future<Map<String, dynamic>?> _makeRequest(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
    }
    return null;
  }

  LatLng _parseLatLng(Map<String, dynamic> jsonResponse) {
    final location = jsonResponse['results'][0]['geometry']['location'];
    return LatLng(location['lat'], location['lng']);
  }

  Cep _parseCep(Map<String, dynamic> result) {
    String? cep;
    String? logradouro;
    String? bairro;
    String? localidade;
    String? uf;
    String? estado;
    String? ddd;

    for (var component in result['address_components']) {
      if (component['types'].contains('postal_code')) {
        cep = component['long_name'];
      } else if (component['types'].contains('route')) {
        logradouro = component['long_name'];
      } else if (component['types'].contains('sublocality') || component['types'].contains('neighborhood')) {
        bairro = component['long_name'];
      } else if (component['types'].contains('locality')) {
        localidade = component['long_name'];
      } else if (component['types'].contains('administrative_area_level_1')) {
        uf = component['short_name'];
        estado = component['long_name'];
      }
    }

    return Cep(
      cep: cep ?? 'N/A',
      logradouro: logradouro ?? 'N/A',
      bairro: bairro ?? 'N/A',
      localidade: localidade ?? 'N/A',
      uf: uf ?? 'N/A',
      estado: estado ?? 'N/A',
      ddd: ddd ?? 'N/A',
    );
  }

}
