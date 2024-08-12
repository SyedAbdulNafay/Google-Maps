import 'dart:async';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final focusnode = useFocusNode();
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
      floatingActionButton: GestureDetector(
        onTap: () {
          cameraToPosition(currentP.value!);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(Icons.my_location),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: currentP.value == null
          ? const Center(
              child: Text("Loading"),
            )
          : Stack(children: [
              GoogleMap(
                zoomControlsEnabled: false,
                onTap: (LatLng coordinates) {
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
                                focusnode.unfocus();
                                textController.clear();
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
                                  final parsed = jsonDecode(response)
                                      as Map<String, dynamic>;

                                  double _currentLat = parsed["result"]
                                      ["geometry"]["location"]["lat"];
                                  double _currentLng = parsed["result"]
                                      ["geometry"]["location"]["lng"];

                                  markers.value['myLocation'] = Marker(
                                    markerId: const MarkerId('myLocation'),
                                    position: LatLng(
                                      _currentLat,
                                      _currentLng,
                                    ),
                                    infoWindow: const InfoWindow(
                                        title: 'Details go here'),
                                  );
                                  isTapped.value = false;
                                  cameraToPosition(
                                      LatLng(_currentLat, _currentLng));
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: isTapped.value
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      if (isTapped.value)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                            onPressed: () {
                              isTapped.value = false;
                              focusnode.unfocus();
                            },
                          ),
                        ),
                      Expanded(
                        child: TextField(
                          focusNode: focusnode,
                          onTap: () {
                            isTapped.value = true;
                          },
                          onChanged: (value) {
                            placeAutocomplete(value);
                          },
                          decoration: InputDecoration(
                            prefixIcon: isTapped.value
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/google-maps-2020-icon.svg',
                                      height: 10,
                                      width: 10,
                                    ),
                                  ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color:
                                    isTapped.value ? Colors.white : Colors.grey,
                                fontSize: 20),
                            fillColor: isTapped.value
                                ? Colors.grey[400]
                                : Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
    );
  }
}
