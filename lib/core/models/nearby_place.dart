import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPlace {
  String placeId;
  LatLng position;
  String name;
  List<String> types;
  String businessStatus;
  String formattedAddress;
  String formattedPhoneNumber;
  String photoReference;
  double rating;

  NearbyPlace({
    required this.placeId,
    required this.position,
    required this.name,
    required this.types,
    required this.businessStatus,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.photoReference,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'position': position,
      'name': name,
      'types': types,
      'businessStatus': businessStatus,
      'formattedAddress': formattedAddress,
      'formattedPhoneNumber': formattedPhoneNumber,
      'photoReference': photoReference,
      'rating': rating,
    };
  }

  factory NearbyPlace.fromJson(Map<String, dynamic> map) {
    return NearbyPlace(
      placeId: map['placeId'] as String,
      position: map['position'] as LatLng,
      name: map['name'] as String,
      types: map['types'].cast<String>(),
      businessStatus: map['businessStatus'] as String,
      formattedAddress: map['formattedAddress'] as String,
      formattedPhoneNumber: map['formattedPhoneNumber'] as String,
      photoReference: map['photoReference'] as String,
      rating: map['rating'] as double,
    );
  }

  set setFormattedAdress(String formattedAddress) =>
      this.formattedAddress = formattedAddress;

  set setformattedPhoneNumber(String formattedPhoneNumber) =>
      this.formattedPhoneNumber = formattedPhoneNumber;
}
