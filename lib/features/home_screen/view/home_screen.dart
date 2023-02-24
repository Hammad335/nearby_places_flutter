import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_places_flutter/constants/constants.dart';
import 'package:nearby_places_flutter/features/home_screen/controller/home_controller.dart';
import 'package:nearby_places_flutter/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final _controller = Get.find<HomeController>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.init(context);
    return Scaffold(
      floatingActionButton: FabCircularMenuButton(
        controller: _controller,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: _controller.size.width,
                    height: _controller.size.height - 28,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: Constants.initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.mapController.value.complete(controller);
                      },
                    ),
                  ),
                  _controller.searchToggle.value
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(15, 40, 15, 5),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _controller.textController.value,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
