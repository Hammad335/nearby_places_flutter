import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPlace {
  LatLng position;
  String name;
  List<String> types;
  String businessStatus;
  String photoReference;
  double rating;

  NearbyPlace({
    required this.position,
    required this.name,
    required this.types,
    required this.businessStatus,
    required this.photoReference,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'name': name,
      'types': types,
      'businessStatus': businessStatus,
      'photoReference': photoReference,
      'rating': rating,
    };
  }

  factory NearbyPlace.fromJson(Map<String, dynamic> map) {
    return NearbyPlace(
      position: map['position'] as LatLng,
      name: map['name'] as String,
      types: map['types'].cast<String>(),
      businessStatus: map['businessStatus'] as String,
      photoReference: map['photoReference'] as String,
      rating: map['rating'] as double,
    );
  }
}
