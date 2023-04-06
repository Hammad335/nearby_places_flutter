import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_places_flutter/constants/constants.dart';

// todo place your api key here
const API_KEY = Constants.API_KEY;
const TYPE = 'geocode';

class HttpService {
  Future<http.Response> getNearbyPlaces(LatLng location, int radius) async {
    final lat = location.latitude;
    final lng = location.longitude;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$lat,$lng&radius=$radius&key=$API_KEY';

    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      rethrow;
    }
  }

  Future<http.Response> getMoreNearbyPlaces(String token) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$API_KEY';
    try {
      return await http.get(Uri.parse(url));
    } catch (exception) {
      rethrow;
    }
  }

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
