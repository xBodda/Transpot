

import 'dart:async';

import 'package:transpot/models/driver.dart';
import 'package:transpot/utils/constants.dart';

class DriverService {
  static List<Driver> getNearbyDrivers() {
    return DummyData.nearbyDrivers;
  }
}
