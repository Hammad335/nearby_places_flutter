import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPlace {
  LatLng position;
  String name;
  List<String> types;
  String businessStatus;

  NearbyPlace({
    required this.position,
    required this.name,
    required this.types,
    required this.businessStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'name': name,
      'types': types,
      'businessStatus': businessStatus,
    };
  }

  factory NearbyPlace.fromJson(Map<String, dynamic> map) {
    return NearbyPlace(
      position: map['position'] as LatLng,
      name: map['name'] as String,
      types: map['types'].cast<String>(),
      businessStatus: map['businessStatus'] as String,
    );
  }
}
