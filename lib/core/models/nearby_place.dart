import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/core/models/models.dart';

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
  List<Review> reviews;
  List<PlacePhoto> photos;

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
    required this.reviews,
    required this.photos,
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
      'reviews': reviews,
      'photos': photos,
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
      reviews: map['reviews'].cast<Review>(),
      photos: map['photos'].cast<PlacePhoto>(),
    );
  }
}
