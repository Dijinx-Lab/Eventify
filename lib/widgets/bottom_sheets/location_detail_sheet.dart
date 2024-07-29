import 'dart:async';

import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetailSheet extends StatefulWidget {
  final double lat;
  final double lng;
  final String address;
  const LocationDetailSheet(
      {super.key, required this.lat, required this.lng, required this.address});

  @override
  State<LocationDetailSheet> createState() => _LocationDetailSheetState();
}

class _LocationDetailSheetState extends State<LocationDetailSheet> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _center;

  @override
  void initState() {
    _center = LatLng(widget.lat, widget.lng);
    super.initState();
  }

  _getMarker() {
    return {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _center!,
      ),
    };
  }

  _openMaps() async {
    Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${widget.lat},${widget.lng}');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Location",
              style: TextStyle(
                  color: ColorStyle.secondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: ColorStyle.primaryColorLight, size: 20),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.address,
                  style: const TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                onPressed: () {
                  _openMaps();
                },
                icon: const Icon(
                  Icons.open_in_new,
                  color: ColorStyle.secondaryTextColor,
                  size: 16,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: FutureBuilder(
                      future: Future.delayed(const Duration(milliseconds: 500)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return _center != null
                              ? GoogleMap(
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    if (!_controller.isCompleted) {
                                      _controller.complete(controller);
                                    }
                                  },
                                  zoomControlsEnabled: false,
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
                              : Container();
                        } else {
                          return Container();
                        }
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
