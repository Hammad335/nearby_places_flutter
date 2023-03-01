import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';

class SearchTextWidget extends StatelessWidget {
  final HomeController controller;
  final String hintText;
  final bool searchSinglePlace;
  final TextEditingController? destTextController;
  final double? paddingTop;

  const SearchTextWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.searchSinglePlace,
    this.destTextController,
    this.paddingTop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, paddingTop ?? 30, 15, 5),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextFormField(
              controller:
                  destTextController ?? controller.searchTextController.value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: InputBorder.none,
                hintText: hintText,
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
                      : SizedBox(
                          width: controller.size.width * 0.26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              !searchSinglePlace && (null != destTextController)
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.search),
                                    )
                                  : const SizedBox.shrink(),
                              IconButton(
                                onPressed: () {
                                  searchSinglePlace
                                      ? controller.toggleSearch()
                                      : controller.toggleGetDirections();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              onChanged: (text) {
                controller.onTextChanged(text, searchSinglePlace);
              },
            ),
          )
        ],
      ),
    );
  }
}
