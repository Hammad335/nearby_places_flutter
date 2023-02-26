import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class CustomContainer extends StatelessWidget {
  final HomeController controller;
  final Widget child;

  const CustomContainer({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 15,
      child: Container(
        height: 200,
        width: controller.size.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.7),
        ),
        child: child,
      ),
    );
  }
}
