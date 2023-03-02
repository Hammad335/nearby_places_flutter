import 'package:http/http.dart' as http;

// todo place your api key here
const API_KEY = 'api-key-here';
const TYPE = 'geocode';

class HttpService {
  Future<http.Response> searchPlaces(String query) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$query&types=$TYPE&key=$API_KEY';
    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      rethrow;
    }
  }

  Future<http.Response> getPlace(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$API_KEY';
    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      rethrow;
    }
  }

  Future<http.Response> getDirections(String origin, String destination) async {
    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$origin&destination=$destination&key=$API_KEY';
    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      rethrow;
    }
  }
}
