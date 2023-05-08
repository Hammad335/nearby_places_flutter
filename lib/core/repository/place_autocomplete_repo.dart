import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/src/response.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/services/http_service.dart';
import 'dart:convert' as convert;

class PlaceAutocompleteRepo {
  late HttpService _httpService;

  PlaceAutocompleteRepo() {
    _httpService = HttpService();
  }

  Future<Map<String, dynamic>> getNearbyPlaces({
    LatLng? location,
    int? radius,
    String? tokenKey,
  }) async {
    try {
      Response response;
      if (null == tokenKey) {
        response = await _httpService.getNearbyPlaces(location!, radius!);
      } else {
        response = await _httpService.getMoreNearbyPlaces(tokenKey);
      }
      var json = convert.jsonDecode(response.body);
      var placesJson = json['results'] as List;

      // token for more nearbyPlaces
      String token = json['next_page_token'] ?? 'none';

      List<NearbyPlace> nearbyPlaces = <NearbyPlace>[];
      String fields = 'formatted_address%2Cformatted_phone_number';
      
      for (var place in placesJson) {
        // fetching more place details like address and contact number
        var placeDetails = await getPlaceById(place['place_id'], fields);

        var location = place['geometry']['location'];
        String? photoRef = place['photos'] != null
            ? place['photos'][0]['photo_reference']
            : null;
        double? rating =
        place['rating'] != null ? place['rating'].toDouble() : 0.0;

        nearbyPlaces.add(
          NearbyPlace(
            position: LatLng(location['lat'], location['lng']),
            name: place['name'] ?? 'No Name',
            types: place['types'].cast<String>(),
            businessStatus: place['business_status'] ?? '-',
            formattedAddress: placeDetails['formatted_address'] ?? 'None Given',
            formattedPhoneNumber:
            placeDetails['formatted_phone_number'] ?? 'None Given',
            photoReference: photoRef ?? '',
            rating: rating ?? 0.0,
          ),
        );
      }
      return {
        'nearby_places': nearbyPlaces,
        'token': token,
      };
    } catch (exception) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDirection(String origin,
      String destination) async {
    try {
      var response = await _httpService.getDirections(origin, destination);
      var json = convert.jsonDecode(response.body);
      final polyline = json['routes'][0]['overview_polyline']['points'];
      final decodedPolyline = PolylinePoints().decodePolyline(polyline);
      return {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'poly_line': polyline,
        'polyline_decoded': decodedPolyline,
      };
    } catch (exception) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPlaceById(String placeId,
      String fields) async {
    try {
      var response = await _httpService.getPlace(placeId, fields);
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
