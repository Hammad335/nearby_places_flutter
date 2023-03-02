import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/core/widgets/widgets.dart';
import '../../features/home_screen/controller/home_controller.dart';

class ResultsNotFoundWidget extends StatelessWidget {
  final HomeController controller;

  const ResultsNotFoundWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      controller: controller,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Results not found!',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  // fontWeight: FontWeight.w200,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  child: const Text('Dismiss'),
                  onPressed: () {
                    controller.searchController.showResult.value = false;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
