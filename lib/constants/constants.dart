import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const API_KEY = 'your-api-key';

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
