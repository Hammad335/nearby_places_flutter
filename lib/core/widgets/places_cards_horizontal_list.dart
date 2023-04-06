import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/places_page_view_controller.dart';
import 'widgets.dart';

class PlacesCardsHorizontalList extends StatelessWidget {
  final HomeController homeController;
  final PlacesPageViewController _placesPageViewController =
      Get.find<PlacesPageViewController>();

  PlacesCardsHorizontalList({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      child: SizedBox(
        height: 200,
        width: homeController.size.width,
        child: Obx(
          () => PageView.builder(
            controller: _placesPageViewController.pageController,
            itemCount:
                homeController.nearbyPlacesController.nearbyPlaces.length,
            itemBuilder: (BuildContext context, int index) {
              return PlaceCard(
                index: index,
                controller: _placesPageViewController,
              );
            },
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final int index;
  final PlacesPageViewController controller;

  const PlaceCard({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    NearbyPlace currentPlace = controller.getNearbyPlaceByIndex(index);
    return AnimatedBuilder(
      animation: controller.pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (controller.pageController.position.haveDimensions) {
          value = controller.pageController.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            // width: double.infinity,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          controller.toggleCardTapped();
          // Todo
        },
        child: Center(
          child: Container(
            height: controller.screenSize.height * 0.13,
            width: controller.screenSize.width * 0.78,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: controller.screenSize.height * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          controller
                              .getPlaceImageUrl(currentPlace.photoReference),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: controller.screenSize.width * 0.38,
                        child: Text(
                          currentPlace.name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      PlaceRatings(currentPlace: currentPlace),
                      SizedBox(
                        width: 170.0,
                        child: Text(
                          currentPlace.businessStatus,
                          style: TextStyle(
                            color: currentPlace.businessStatus == 'OPERATIONAL'
                                ? Colors.green
                                : currentPlace.businessStatus == '-'
                                    ? Colors.blue
                                    : Colors.red,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
