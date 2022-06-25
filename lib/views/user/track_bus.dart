import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transpot/components/bottom_sheet_tracking.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/map_service.dart';
import 'package:transpot/services/notifier_service.dart';
import 'package:transpot/utils/api.dart';
import 'package:transpot/utils/constants.dart';
import 'package:location/location.dart' as loc;

class TrackBusScreenArguments {
  final double passedLat;
  final double passedLong;
  final String busId;

  TrackBusScreenArguments(this.passedLat, this.passedLong, this.busId);
}

class TrackBus extends StatefulWidget {
  const TrackBus({Key? key}) : super(key: key);

  static String routeName = "/track_bus";

  @override
  _TrackBusState createState() => _TrackBusState();
}

class _TrackBusState extends State<TrackBus> {
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  final Set<Marker> _markers = Set<Marker>();
  final Set<Polygon> _polygons = Set<Polygon>();
  final Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  var DistanceofLocation;
  var TimeofLocation;

  bool trackLiveLocation = false;
  bool trafficEnabledflow = false;

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  late var directions;

  String place1 = 'Enter Origin';
  String place2 = 'Enter Destination';

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.0459733, 31.352115),
    zoom: 18,
  );

  CameraPosition getCamera(double lat, double lng) {
    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 18,
      );
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    place1;
    place2;
    _setMarker(const LatLng(30.047040, 31.346476));
    location.changeSettings(
        interval: 1000, accuracy: loc.LocationAccuracy.low, distanceFilter: 10);
    // location.enableBackgroundMode(enable: true);
    // getLiveLocation();
  }

  String userName = '';
  String phoneNumber = '';
  String busId = '';

  String busName = '';
  int busSeats = 0;

  double latest_lat = 0;
  double latest_lng = 0;

  User? userx = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TrackBusScreenArguments;
    latest_lat = args.passedLat;
    latest_lng = args.passedLong;
    String inString = latest_lat.toStringAsFixed(12);
    double inDoubleLat = double.parse(inString);
    String inStringg = latest_lng.toStringAsFixed(12);
    double inDoubleLng = double.parse(inStringg);
    final mapModel = Provider.of<MapService>(context);
    final uiNotifiersModel = Provider.of<UINotifiersModel>(context);

    return GestureDetector(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getLiveLocation();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.place_outlined),
        ),
        appBar: AppBar(
          title: const Text(
            "Track Bus",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          backgroundColor: secondaryColorDark,
        ),
        drawer: const AppDrawer(),
        resizeToAvoidBottomInset: true,
        body: Stack(
            // width: double.infinity,
            children: [
              SlidingUpPanel(
                onPanelSlide: uiNotifiersModel.setOriginDestinationVisibility,
                onPanelOpened: () {
                  uiNotifiersModel.onPanelOpen();
                  // mapModel.panelIsOpened();
                },
                onPanelClosed: () {
                  uiNotifiersModel.onPanelClosed();
                  // mapModel.panelIsClosed();
                },
                maxHeight: MediaQuery.of(context).size.height / 1.3,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                color: primaryLightColor,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 30.0,
                    color: Color.fromARGB(0, 31, 24, 24),
                  )
                ],
                controller: uiNotifiersModel.panelController,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                body: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: getCamera(inDoubleLat, inDoubleLng),
                  myLocationEnabled: trackLiveLocation,
                  // myLocationButtonEnabled: true,
                  trafficEnabled: true,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  zoomGesturesEnabled: true,
                  polygons: _polygons,
                  polylines: _polylines,
                  onCameraMove: mapModel.onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: mapModel.markers,
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                    });
                  },
                ),
                collapsed: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Expanded(child: SizedBox()),
                  ],
                ),
                panel: BottomSheetTrackingMenu(
                    userName, phoneNumber, busName, busSeats, args.busId),
              ),
            ]),
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  getOriginLocations() async {
    var getplace1 = await PlacesAutocomplete.show(
      context: context,
      apiKey: API.apiKey,
      mode: Mode.fullscreen,
      types: [],
      strictbounds: false,
      components: [Component(Component.country, 'Eg')],
      onError: (err) {
        var snackBar = const SnackBar(content: Text("An Error happened!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    await displayOriginPrediction(getplace1, ScaffoldMessenger.of(context));
  }

  getDestinationLocations() async {
    var getplace1 = await PlacesAutocomplete.show(
      context: context,
      apiKey: API.apiKey,
      mode: Mode.fullscreen,
      types: [],
      strictbounds: false,
      components: [Component(Component.country, 'Eg')],
      onError: (err) {
        var snackBar = const SnackBar(content: Text("An Error happened!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    await displayDestinationPrediction(
        getplace1, ScaffoldMessenger.of(context));
  }

  Future<void> displayOriginPrediction(
      Prediction? p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      return;
    }
    // get detail (lat/lng)
    final _places = GoogleMapsPlaces(
      apiKey: API.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;

    setState(() {
      place1 = p.description!;
      _originController.text = place1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.description}'),
        duration: Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondaryColorDark,
      ),
    );
  }

  Future<void> displayDestinationPrediction(
      Prediction? p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      return;
    }
    // get detail (lat/lng)
    final places = GoogleMapsPlaces(
      apiKey: API.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;
    setState(() {
      place2 = p.description!;
      _destinationController.text = place2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.description}'),
        duration: Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondaryColorDark,
      ),
    );
  }

  ElevatedButton busButton(String time) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        side: const BorderSide(width: 2, color: primaryColor),
        primary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      icon: const Icon(Icons.bus_alert_outlined, color: primaryColor),
      label: Text(
        time,
        style: const TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            color: primaryColor),
      ),
    );
  }

  void getLiveLocation() {
    setState(() {
      trackLiveLocation = true;
      trafficEnabledflow = true;
    });

    location.enableBackgroundMode(enable: true);
    GeoData data;
    var currentlat;
    var currentlong;
    var i = 0;
    //get cureent address & lat & long
    //f 10 seconds are passed AND* if the phone is moved at least 5 meters, give the location.
    //location.changeSettings(accuracy: loc.LocationAccuracy.balanced,interval: 1000); ///not sure ,distanceFilter: 2
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print("error in listen location${onError}");

      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      //GeoData convert current lat long to address
      data = await Geocoder2.getDataFromCoordinates(
          latitude: currentlocation.latitude!,
          longitude: currentlocation.longitude!,
          googleMapApiKey: API.apiKey);
      setState(() {
        place1 = data.address;
      });
      //Formated Address
      print("the cureent address is------${data.address}");

      currentlong = currentlocation.longitude;
      currentlat = currentlocation.latitude;

      print('the current live  lat is ${currentlocation.latitude}');
      print('the current live long is ${currentlocation.longitude}');

      setState(() async {
        if (_locationSubscription != null) {
          if (place1 != data.address) {
            setState(() async {
              place1 = data.address;
            });
          }
        }
      });
    });
    print("Current lat ${currentlat}");
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
          infoWindow: InfoWindow(
              title: "A",
              onTap: () {
                const TextField(
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.place,
                      color: Colors.blueGrey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 5.0),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: "A",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 0.01,
                      color: Colors.black),
                );
              },
              snippet: ""),
        ),
      );
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    //var status = await Permission.location.status;
    //var status = Permission.location;
    if (status.isGranted) {
      print('permission is granted!');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      print('isPermanentlyDenied');
    }
  }

  void _listenLocation_Trail() {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    GeoData data;

//get cureent address & lat & long
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print("error in listen location${onError}");
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      //GeoData
      data = await Geocoder2.getDataFromCoordinates(
          latitude: currentlocation.latitude!,
          longitude: currentlocation.longitude!,
          googleMapApiKey: API.apiKey);

      //Formated Address
      print("the cureent address is------${data.address}");
      print('the current live  lat is ${currentlocation.latitude}');
      print('the current live long is ${currentlocation.longitude}');
    });
  }
}
