import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import '../models/models.dart';

class PlaceItem extends StatelessWidget {
  final Place place;
  final HomeController controller;

  const PlaceItem({
    super.key,
    required this.place,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                place.description ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
