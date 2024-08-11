import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps/services/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/autocomplete_predictions.dart';
import '../models/network_utils.dart';
import '../models/place_autocomplete.dart';

class ThirdMapPage extends HookWidget {
  ThirdMapPage({super.key});

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();
  Map<PolylineId, Polyline> polylines = {};
  // double latitude = 0;
  // double longitude = 0;
  // List<AutocompletePrediction> placePredictions = [];

  @override
  Widget build(BuildContext context) {
    final currentP = useState<LatLng?>(const LatLng(0, 0));
    final markers = useState<Map<String, Marker>>({});
    final isTapped = useState(false);
    final placePredictions = useState<List<AutocompletePrediction>>([]);

    Future<void> requestLocationPermission() async {
      PermissionStatus permissionGranted;

      permissionGranted = await _locationController.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationController.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission not granted');
        }
      }
    }

    Future<void> requestLocationService() async {
      bool serviceEnabled;

      serviceEnabled = await _locationController.serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await _locationController.requestService();
        if (!serviceEnabled) {
          throw Exception('Location service not granted');
        }
      }
    }

    Future<void> cameraToPosition(LatLng pos) async {
      final GoogleMapController controller = await _mapController.future;
      CameraPosition newCameraPosition = CameraPosition(
        target: pos,
        zoom: 13,
      );
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          newCameraPosition,
        ),
      );
    }

    Future<void> getCurrentLoction() async {
      LocationData currentPosition = await _locationController.getLocation();
      // latitude = currentPosition.latitude!;
      // longitude = currentPosition.longitude!;
      currentP.value = LatLng(
        currentPosition.latitude!,
        currentPosition.longitude!,
      );
      final marker = Marker(
        markerId: const MarkerId('myLocation'),
        position: currentP.value!,
        infoWindow: const InfoWindow(title: "Details go here"),
      );

      markers.value['myLocation'] = marker;
      cameraToPosition(currentP.value!);
    }

    Future<void> initLocation() async {
      try {
        await requestLocationPermission();
        await requestLocationService();
        await getCurrentLoction();
        // await _listenLocationUpdates();
        // await _getPolyLinePoints();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    void placeAutocomplete(String query) async {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json', // unencoder path
        {
          "input": query,
          "key": GOOGLE_MAPS_API_KEY,
        },
      );

      String? response = await NetworkUtility.fetchUrl(uri);

      if (response != null) {
        PlaceAutocompleteReponse result =
            PlaceAutocompleteReponse.parseAutocompleteResult(response);
        if (result.predictions != null) {
          placePredictions.value = result.predictions!;
        }
      }
    }

    useEffect(() {
      initLocation();
      return null;
    }, const []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: currentP.value == null
          ? const Center(
              child: Text("Loading"),
            )
          : Stack(children: [
              GoogleMap(
                onTap: (LatLng coordinates) {
                  // latitude = coordinates.latitude;
                  // longitude = coordinates.longitude;
                  currentP.value = LatLng(
                    coordinates.latitude,
                    coordinates.longitude,
                  );
                  final marker = Marker(
                    markerId: const MarkerId('myLocation'),
                    position: currentP.value!,
                    infoWindow: const InfoWindow(title: 'Details will go here'),
                  );

                  markers.value['myLocation'] = marker;
                },
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: currentP.value!,
                  zoom: 13,
                ),
                markers: markers.value.values.toSet(),
                polylines: Set<Polyline>.of(polylines.values),
              ),
              Container(
                width: isTapped.value ? double.infinity : 0,
                height: isTapped.value ? double.infinity : 0,
                color: Colors.white,
                child: placePredictions.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: ListView.builder(
                          itemCount: placePredictions.value.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                Uri uri = Uri.https(
                                  "maps.googleapis.com",
                                  '/maps/api/place/details/json',
                                  {
                                    "placeid":
                                        placePredictions.value[index].placeId,
                                    "key": GOOGLE_MAPS_API_KEY,
                                  },
                                );
                                String? response =
                                    await NetworkUtility.fetchUrl(uri);
                                if (response != null) {
                                  debugPrint(response);
                                }
                              },
                              title: Text(
                                  placePredictions.value[index].description!),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 10,
                  right: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
                  child: TextField(
                    onTap: () {
                      isTapped.value = true;
                    },
                    onChanged: (value) {
                      placeAutocomplete(value);
                    },
                    decoration: InputDecoration(
                      prefix: SvgPicture.asset(
                        'assets/images/google-maps-2020-icon.svg',
                        height: 20,
                        width: 20,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
    );
  }
}
