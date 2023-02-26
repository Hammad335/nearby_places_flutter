import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/services/http_service.dart';
import 'dart:convert' as convert;

class PlaceAutocompleteRepo {
  late HttpService _httpService;

  PlaceAutocompleteRepo() {
    _httpService = HttpService();
  }

  Future<Map<String, dynamic>> getPlace(String placeId) async {
    try {
      var response = await _httpService.getPlace(placeId);
      var json = convert.jsonDecode(response.body);
      return json['result'] as Map<String, dynamic>;
    } catch (exception) {
      rethrow;
    }
  }

  Future<List<Place>> searchPlaces(String query) async {
    try {
      var response = await _httpService.searchPlaces(query);
      var json = convert.jsonDecode(response.body);
      var placesListJson = json['predictions'] as List;
      return placesListJson.map((place) => Place.fromJson(place)).toList();
    } catch (exception) {
      rethrow;
    }
  }
}
