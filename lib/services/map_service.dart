import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transpot/models/driver.dart';
import 'package:transpot/services/location_service.dart';
import 'package:transpot/utils/api.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/utils.dart';
import 'package:location/location.dart' as location;

class MapService extends ChangeNotifier {
  final Set<Marker> _markers = Set();

  double currentZoom = 19;
  
  location.Location _location = location.Location();

  StreamSubscription<location.LocationData>? _locationSubscription;

  late LatLng _currentPosition, _destinationPosition, _pickupPosition;

  TextEditingController pickupFormFieldController = TextEditingController();

  late GoogleMapController _mapController;

  TextEditingController destinationFormFieldController = TextEditingController();

  LocationService _mapRepository = LocationService(); 

  late double currentlat;
  late double currentlong;

  double busLat = 0;
  double busLng = 0;

  MapService() {
    fetchNearbyDrivers(DummyData.nearbyDrivers);
    // _getUserLocation();
  }

  void fetchNearbyDrivers(List<Driver> list) {
    if (list.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((driver) async {
        markers.add(Marker(
            markerId: MarkerId(driver.driverId),
            infoWindow: InfoWindow(title: driver.busDetail.busCompanyName),
            position: driver.currentLocation,
            anchor: const Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(await Utils.getBytesFromAsset("assets/carIcon.png", 120))));
        notifyListeners();
      });
      
    }
  }

  Future<void> getUserLocation() async{
    _location.changeSettings(interval: 1000, accuracy: location.LocationAccuracy.low, distanceFilter: 10);
    //get cureent address & lat & long
    //f 10 seconds are passed AND* if the phone is moved at least 5 meters, give the location.
    _locationSubscription = _location.onLocationChanged.handleError((onError) {
      print("error in listen location${onError}");
    }).listen((location.LocationData currentlocation) async {
      //GeoData convert current lat long to address
      // print('the current live  lat is ${currentlocation.latitude}');
      // print('the current live long is ${currentlocation.longitude}');

      currentlong = currentlocation.longitude!;
      currentlat = currentlocation.latitude!;
    });
    // updatePickupMarker();
    notifyListeners();
  }

  updatePickupMarker() async {
    if (pickupPosition == null) return;
    _markers.add(Marker(
        markerId: const MarkerId("PickupMarker"),
        position: pickupPosition,
        draggable: true,
        onDragEnd: onPickupMarkerDragged,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(await Utils.getBytesFromAsset("images/pickupIcon.png", 80))));
    notifyListeners();
  }

  void onPickupMarkerDragged(LatLng value) async {
    _pickupPosition = value;
    // pickupFormFieldController.text = await mapRepo.getPlaceNameFromLatLng(value);
    onPickupPositionChanged();
    notifyListeners();
  }

  void onPickupPositionChanged() {
    updatePickupMarker();
    mapController.animateCamera(CameraUpdate.newLatLngZoom(pickupPosition, randomZoom));
    // if (destinationPosition != null) sendRouteRequest();
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) {
    currentZoom = position.zoom;
    notifyListeners();
  }

  void moveCamera(double lat, double lng) {
    busLat = lat;
    busLng = lng;
    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  LatLng get currentPosition => _currentPosition;

  LatLng get destinationPosition => _destinationPosition;

  LatLng get pickupPosition => _pickupPosition;

  LocationService get mapRepo => _mapRepository;

  GoogleMapController get mapController => _mapController;

  // ignore: non_constant_identifier_names
  get Currentlat => currentlat;

  // ignore: non_constant_identifier_names
  get Currentlong => currentlong;

  // ignore: non_constant_identifier_names
  double get BusLat => busLat;

  // ignore: non_constant_identifier_names
  double get BusLng => busLng;

  get randomZoom => 13.0 + Random().nextInt(4);
}