import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class SearchTextWidget extends StatelessWidget {
  final HomeController controller;

  const SearchTextWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 5),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller: controller.textController.value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: InputBorder.none,
                hintText: 'Search place here',
                suffixIcon: Obx(
                  () => controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            controller.toggleSearch();
                          },
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              onChanged: (text) {
                controller.onTextChanged(text);
              },
            ),
          )
        ],
      ),
    );
  }
}
