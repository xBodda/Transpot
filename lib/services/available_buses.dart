import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:transpot/models/driver.dart';
import 'package:transpot/services/main_variables.dart';

class NearbyDriversModel extends ChangeNotifier {
  late List<Driver> nearbyDrivers;
  final nearbyDriverStreamController = StreamController<List<Driver>>();

  get nearbyDriverList => nearbyDrivers;

  Stream<List<Driver>> get dataStream => nearbyDriverStreamController.stream;

  NearbyDriversModel() {
    MainVariables.getNearbyDrivers(nearbyDriverStreamController);

    dataStream.listen((list) {
      nearbyDrivers = list;
      notifyListeners();
    });
  }

  void closeStream() {
    nearbyDriverStreamController.close();
  }
}
