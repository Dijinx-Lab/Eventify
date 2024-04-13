import 'dart:async';

import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class StepTwoContainer extends StatefulWidget {
  final EventArgs event;
  final Function(EventArgs, bool) onDataFilled;
  const StepTwoContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepTwoContainer> createState() => _StepTwoContainerState();
}

class _StepTwoContainerState extends State<StepTwoContainer> {
  final TextEditingController _locationValueController =
      TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _center;
  String city = "";
  late EventArgs eventArgs;

  @override
  initState() {
    super.initState();
    eventArgs = widget.event;
    if (eventArgs.latitude != null) {
      _locationValueController.text = eventArgs.address ?? "";
      city = eventArgs.city ?? "Karachi";
      _center = LatLng(eventArgs.latitude ?? 0.0, eventArgs.longitude ?? 0.0);
      Future.delayed(const Duration(microseconds: 800)).then((value) {
        _alertParentWidget();
      });
    } else {
      _getCurrentPosition();
    }

    _locationValueController.addListener(() {
      _alertParentWidget();
    });
  }

  _alertParentWidget() async {
    await _getCity(_center!.latitude, _center!.longitude);
    if (_locationValueController.text != "") {
      Future.delayed(const Duration(milliseconds: 700)).then(
        (value) async {
          eventArgs.address = _locationValueController.text;
          eventArgs.city = city;
          eventArgs.latitude = _center!.latitude;
          eventArgs.longitude = _center!.longitude;
          widget.onDataFilled(eventArgs, true);
        },
      );
    } else {
      widget.onDataFilled(eventArgs, false);
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCity(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      setState(() {
        city = placemarks[0].locality ?? "Karachi";
      });
    } catch (e) {
      setState(() {
        city = "Karachi";
      });
    }
  }

  Future<LatLng?> _getCurrentPosition() async {
    Position? currPosition = await _determinePosition();

    if (currPosition != null) {
      _getAddress(currPosition.latitude, currPosition.longitude);
      setState(() {
        _center = LatLng(currPosition.latitude, currPosition.longitude);
      });
    }
    return _center;
  }

  Future<void> animateMapCamera(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _getMarker() {
    return {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _center!,
      ),
    };
  }

  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        _locationValueController.text = "${place.street}, ${place.locality}";
        await _getCity(latitude, longitude);
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: _center != null
                ? GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    markers: _getMarker(),
                    mapType: MapType.normal,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    scrollGesturesEnabled: false,
                    trafficEnabled: false,
                    zoomGesturesEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _center!,
                      zoom: 17.0,
                    ),
                  )
                : Container(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
          child: SizedBox(
            height: 60,
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _locationValueController,
              googleAPIKey: "AIzaSyDjpIILOlFeed05Z6OksQR9SHhmVLbUFpQ",
              inputDecoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                hintText: "Location",
                fillColor: ColorStyle.whiteColor,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorStyle.secondaryTextColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              debounceTime: 600,
              countries: const ["pk"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) async {
                animateMapCamera(CameraPosition(
                  target: LatLng(double.parse(prediction.lat!),
                      double.parse(prediction.lng!)),
                  zoom: 17,
                ));
                await _getCity(double.parse(prediction.lat!),
                    double.parse(prediction.lng!));
                setState(() {
                  _center = LatLng(double.parse(prediction.lat!),
                      double.parse(prediction.lng!));
                });
              },
              itemClick: (Prediction prediction) {
                _locationValueController.text = prediction.description ?? "";
                _locationValueController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0));
              },
              seperatedBuilder: const Divider(),
              isCrossBtnShown: false,
            ),
          ),
        ),
      ],
    );
  }
}
