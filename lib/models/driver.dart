import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  String driverName;
  String driverImage;
  double driverRating;
  String driverId;
  BusDetail busDetail;
  LatLng currentLocation;

  Driver(this.driverName, this.driverImage, this.driverRating, this.driverId, this.busDetail, this.currentLocation);
}

class BusDetail {
  String busId;
  String busCompanyName;
  String busModel;
  String busNumber;

  BusDetail(this.busId, this.busCompanyName, this.busModel, this.busNumber);
}
