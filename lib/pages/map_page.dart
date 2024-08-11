import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double latitude = 0;
  double longitude = 0;
  final Map<String, Marker> _markers = {};

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  final Location _locationController = Location();

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _cameraToPosition(LatLng(
          latitude,
          longitude,
        )),
        child: const Icon(Icons.my_location),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (LatLng coordinates) {
              latitude = coordinates.latitude;
              longitude = coordinates.longitude;
              final marker = Marker(
                markerId: const MarkerId('myLocation'),
                position: LatLng(
                  latitude,
                  longitude,
                ),
                infoWindow: const InfoWindow(title: 'Details will go here'),
              );
              setState(() {
                _markers['myLocation'] = marker;
              });
            },
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 13,
            ),
            markers: _markers.values.toSet(),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 10,
              right: 10,
            ),
            child: TextField(
              decoration: InputDecoration(
                prefix: SvgPicture.asset(
                  'assets/images/google-maps-2020-icon.svg',
                  height: 30,
                  width: 30,
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
        ],
      ),
    );
  }

  Future<void> _initLocation() async {
    try {
      await _requestLocationPermission();
      await _requestLocationService();
      await _getCurrentLoction();
      // await _listenLocationUpdates();
      // await _getPolyLinePoints();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus _permissionGranted;

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission not granted');
      }
    }
  }

  Future<void> _requestLocationService() async {
    bool _serviceEnabled;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        throw Exception('Location service not granted');
      }
    }
  }

  Future<void> _getCurrentLoction() async {
    LocationData currentPosition = await _locationController.getLocation();
    latitude = currentPosition.latitude!;
    longitude = currentPosition.longitude!;
    final marker = Marker(
      markerId: MarkerId('myLocation'),
      position: LatLng(
        latitude,
        longitude,
      ),
      infoWindow: const InfoWindow(title: "Details go here"),
    );

    setState(() {
      _markers['myLocation'] = marker;
      _cameraToPosition(LatLng(latitude, longitude));
    });
  }

  // Future<void> _listenLocationUpdates() async {
  //   _locationController.onLocationChanged
  //       .listen((LocationData currentLocation) {
  //     if (currentLocation.latitude != null &&
  //         currentLocation.longitude != null) {
  //       setState(() {
  //         _currentP = LatLng(
  //           currentLocation.latitude!,
  //           currentLocation.longitude!,
  //         );
  //         _cameraToPosition(_currentP!);
  //       });
  //     }
  //   });
  // }

  // Future<void> _getPolyLinePoints() async {
  //   List<LatLng> polylineCoordinates = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     request: PolylineRequest(
  //         origin: PointLatLng(
  //           _pGooglePlex.latitude,
  //           _pGooglePlex.longitude,
  //         ),
  //         destination: PointLatLng(
  //           _pApplePark.latitude,
  //           _pApplePark.longitude,
  //         ),
  //         mode: TravelMode.driving),
  //     googleApiKey: GOOGLE_MAPS_API_KEY,
  //   );

  //   for (PointLatLng point in result.points) {
  //     polylineCoordinates.add(LatLng(
  //       point.latitude,
  //       point.longitude,
  //     ));
  //   }

  //   _generatePolyLineFromCoordinates(polylineCoordinates);
  // }

  void _generatePolyLineFromCoordinates(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _newCameraPosition,
      ),
    );
  }
}
