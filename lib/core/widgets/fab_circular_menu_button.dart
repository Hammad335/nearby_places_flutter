import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class FabCircularMenuButton extends StatelessWidget {
  final HomeController controller;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  FabCircularMenuButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      key: fabKey,
      alignment: Alignment.bottomLeft,
      fabColor: Colors.blue.shade50,
      fabOpenColor: Colors.red.shade100,
      ringDiameter: 250,
      ringWidth: 60,
      ringColor: Colors.blue.shade50,
      fabSize: 60,
      children: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.searchController.toggleSearch();
            _closeFabMenu();
          },
        ),
        IconButton(
          icon: const Icon(Icons.navigation),
          onPressed: () {
            controller.searchController.toggleGetDirections();
            _closeFabMenu();
          },
        ),
      ],
    );
  }

  _closeFabMenu() {
    if (fabKey.currentState?.isOpen ?? true) {
      fabKey.currentState?.close();
    }
  }
}
