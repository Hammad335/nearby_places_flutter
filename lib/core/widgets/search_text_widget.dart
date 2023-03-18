import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/widgets/loading_indicator.dart';
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
              controller: destTextController ??
                  controller.searchController.originTextController.value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: InputBorder.none,
                hintText: hintText,
                suffixIcon: Obx(() {
                  controller.isLoading.value;
                  return searchSinglePlace
                      ? controller.isLoading.value
                          ? const LoadingIndicator()
                          : _iconButtonClose
                      : !(null == destTextController)
                          ? _iconButtonsSearchAndClose
                          : const SizedBox.shrink();
                }),
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

  Widget get _iconButtonsSearchAndClose {
    return controller.isLoading.value
        ? const LoadingIndicator()
        : SizedBox(
            width: controller.size.width * 0.26,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.getDirection();
                  },
                  icon: const Icon(Icons.search),
                ),
                _iconButtonClose,
              ],
            ),
          );
  }

  Widget get _iconButtonClose {
    return IconButton(
      onPressed: () {
        searchSinglePlace
            ? controller.searchController.toggleSearch()
            : controller.searchController.toggleGetDirections();
      },
      icon: const Icon(Icons.close),
    );
  }
}
