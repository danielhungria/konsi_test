import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/core/utils/constants.dart';

class GeocodingService {

  Future<LatLng?> getLatLngFromCep(String cep) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$cep&key=$API_KEY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'OK') {
        final location = jsonResponse['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      } else {
        print('Erro na geocodificação: ${jsonResponse['status']}');
        return null;
      }
    } else {
      print('Falha ao se conectar com a API');
      return null;
    }
  }
}
