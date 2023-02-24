import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late BuildContext context;
  late Size size;
  late Rx<Completer<GoogleMapController>> mapController;
  RxBool searchToggle = false.obs;
  RxBool radiusSlider = false.obs;
  RxBool cardTapped = false.obs;
  RxBool pressedNear = false.obs;
  RxBool getDirections = false.obs;
  late Rx<TextEditingController> textController;

  init(BuildContext context) {
    this.context = context;
    size = MediaQuery.of(context).size;
    mapController = Completer<GoogleMapController>().obs;
    textController = TextEditingController().obs;
  }
}
