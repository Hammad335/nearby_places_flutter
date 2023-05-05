import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const API_KEY = 'your-api-key';

  static const BASE_IMAGE_URL = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=';

  static const DEFAULT_IMAGE_URL = 'https://pic.onlinewebfonts.com/svg/img_546302.png';

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
