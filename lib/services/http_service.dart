import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:http/http.dart' as http;

const BASE_URL =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json?';

// todo place your api key here
const API_KEY = 'your-api-key-here';

const TYPE = 'geocode';

class HttpService {
  Future<http.Response> searchPlaces(String query) async {
    final String url = '${BASE_URL}input=$query&types=$TYPE&key=$API_KEY';
    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }
}
