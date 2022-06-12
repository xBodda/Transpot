import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:transpot/components/drawer.dart';
import 'package:transpot/services/location_service.dart';
import 'package:transpot/utils/api.dart';
import 'package:transpot/utils/constants.dart';
import 'package:transpot/utils/size_config.dart';
import 'package:transpot/views/user/buses.dart';
import 'package:location/location.dart' as loc;

class FindBus extends StatefulWidget {
  const FindBus({Key? key}) : super(key: key);

  static String routeName = "/find_bus";

  @override
  _FindBusState createState() => _FindBusState();
}

class _FindBusState extends State<FindBus> {
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
    target: LatLng(30.047040, 31.346476),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    getLiveLocation();
    place1;
    place2;
    _setMarker(const LatLng(30.047040, 31.346476));
    location.changeSettings(interval: 1000, accuracy: loc.LocationAccuracy.low, distanceFilter: 10);
    location.enableBackgroundMode(enable: true);
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
          //icon:  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),///-------
          //icon:false,
          /*onTap: () {
          print("orginInput");
        //  var XR=Text('$point');
   var t!=orginInput;
         return(<orginInput!>);
 late String OrginInput;
 late String DestinationInput;
         }, */
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Find A Bus",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 20,
              fontFamily: 'Lato',
            ),
          ),
          backgroundColor: secondaryColorDark,
        ),
        drawer: const AppDrawer(),
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              SizedBox(
                width: double.infinity,
                height: 350,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: trackLiveLocation,
                  // myLocationButtonEnabled: true,
                  trafficEnabled: true,
                  polygons: _polygons,
                  polylines: _polylines,

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set.of(_markers),
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                    });
                  },
                ),
              ),
              SizedBox(
                height: getSuitableScreenHeight(10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getSuitableScreenWidth(10),
                  vertical: getSuitableScreenWidth(20),
                ),
                child: SizedBox(
                  child: Column(
                    children: [
                      TextFormField(
                        onTap: getOriginLocations,
                        controller: _originController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (newValue) => place1 = newValue!,
                        onChanged: (value) {
                          place1 = value;
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: 'Lato',
                              color: secondaryColorDark.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                          labelText: "Origin",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: getSuitableScreenWidth(20),
                              horizontal: getSuitableScreenWidth(30)),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                right: getSuitableScreenWidth(25)),
                            child: Icon(
                              Icons.pin_drop_rounded,
                              size: getSuitableScreenWidth(28),
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getSuitableScreenHeight(20),
                      ),
                      TextFormField(
                        onTap: getDestinationLocations,
                        controller: _destinationController,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onSaved: (newValue) => place1 = newValue!,
                        onChanged: (value) {
                          place2 = value;
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontFamily: 'Lato',
                              color: secondaryColorDark.withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                          labelText: "Destination",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: getSuitableScreenWidth(20),
                              horizontal: getSuitableScreenWidth(30)),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                right: getSuitableScreenWidth(25)),
                            child: Icon(
                              Icons.pin_drop_rounded,
                              size: getSuitableScreenWidth(28),
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getSuitableScreenHeight(20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DistanceofLocation != null
                                  ? Text(
                                      "Distance: $DistanceofLocation",
                                      style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          color: secondaryColorDark),
                                    )
                                  : const Text(''),
                              SizedBox(
                                height: getSuitableScreenHeight(10),
                              ),
                              TimeofLocation != null
                                  ? Text(
                                      "Time: $TimeofLocation",
                                      style: const TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          color: secondaryColorDark),
                                    )
                                  : const Text(''),
                              SizedBox(
                                height: getSuitableScreenHeight(10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          getLiveLocation();

                          directions = await LocationService()
                              .getDirections(place1, place2);
                          DistanceofLocation = await LocationService()
                              .getDistance(place1, place2);
                          TimeofLocation =
                              await LocationService().getTime(place1, place2);

                          _goToPlace(
                            directions['start_location']['lat'],
                            directions['start_location']['lng'],
                            directions['bounds_ne'],
                            directions['bounds_sw'],
                          );

                          _setPolyline(
                            directions['polyline_decoded'],
                          );
                          setState(() {
                            DistanceofLocation;
                            TimeofLocation;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        icon: const Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                        ),
                        label: const Text("Check For A Bus",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: getSuitableScreenHeight(20),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pushNamed(Bus.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 2, color: primaryColor),
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        icon: const Icon(
                          Icons.timer,
                          color: primaryColor,
                        ),
                        label: const Text("See Available Buses",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Future<void> displayDestinationPrediction(Prediction? p, ScaffoldMessengerState messengerState) async {
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
        //8t change
        // if(currentlocation.isMock==true){

        if (_locationSubscription != null) {
          if (place1 != data.address) {
            setState(() async {
              place1 = data.address;
              //  directions =
              //   await LocationService().getDirections(place1, place2);
              //  DistanceofLocation =
              //    await LocationService().getDistance(place1, place2);
              //  TimeofLocation =
              //    await LocationService().getTime(place1, place2);

              //  setState(() {
              //    TimeofLocation;
              //     DistanceofLocation;
              //    directions;
              //  });

              //  if(i!=1){
              //     _goToPlace(
              //       directions['start_location']['lat'],
              //       directions['start_location']['lng'],
              //       directions['bounds_ne'],
              //       directions['bounds_sw'],
              //     );
              //  }
              //  i++;

              //     _setPolyline(
              //       directions['polyline_decoded'],
              //     );
            });
            // }), );
          }
        }
        ;
//}
      });
    });
  }
}
