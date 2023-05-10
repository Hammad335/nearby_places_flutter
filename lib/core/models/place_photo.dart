class PlacePhoto {
  final int width;
  final int height;
  final String photoReference;

  const PlacePhoto({
    required this.width,
    required this.height,
    required this.photoReference,
  });

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'photoReference': photoReference,
    };
  }

  factory PlacePhoto.fromJson(Map<String, dynamic> json) {
    return PlacePhoto(
      width: json['width'] as int,
      height: json['height'] as int,
      photoReference: json['photoReference'] as String,
    );
  }
}
