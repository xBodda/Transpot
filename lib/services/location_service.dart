import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:transpot/utils/api.dart';

// import 'package:dio/dio.dart';
class LocationService {
  static const key = API.apiKey;

//1
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key'; //&types=geocode

    var response = await http.get(Uri.parse(url));
    //var json = convert.jsonDecode(response.body);
    //var placeId = json['candidates'][0]['place_id'] as String;
    //return placeId;
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var placeId = json['candidates'][0]['place_id'] as String;
      return placeId;
    } else {
      throw Exception('An error occurred getting places nearby');
    }
  }

//2
  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key'; //place_id=$placeId&types=address&language=en&components=country:en

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var results = json['result'] as Map<String, dynamic>;
      // print ('Response body: ${response.body}');
      return results;
    } else {
      throw Exception('An error occurred getting places nearby');
    }
  }

//3
  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&language=en,ar'; //libraries=places    &region=Eg

    var response = await http.get(Uri.parse(url));

    //return results.json['routes'][0]['legs'][0]['start_location'];
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      print('Response body: ${response.body}');
      var results = {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      };

      // print(results);
      //print ('Response body: ${response.body}');
      return results;
    } else {
      throw Exception(
          'An error occurred getting places nearby "$response.statusCode');
    }
  }

//4
  Future<dynamic> getDistance(var origin, var destination) async {
    //origin='miu cairo'; destination='guc' ;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&language=en,ar&region=Eg'; //libraries=places &region=Eg

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    // var results =  json['routes'][0]['legs'][0]['distance']['text'];
    // print("the get distance is $results");
    //  return results;
//leave it comented
    //json['routes'][0]['legs'][0]['distance'];
    //var results =  json['routes'][0]['legs'][0]['start_location']; "duration"
    //print ("Response body: ${response.body}");
    //return results.json['routes'][0]['legs'][0]['start_location'];

    if (response.statusCode == 200) {
      var results = json['routes'][0]['legs'][0]['distance']['text'];
      print("the get distance is $results");
      //  print ("Response body: ${response.body}");
      return results;
      //return results.json['routes'][0]['legs'][0]['start_location'];
    } else {
      throw Exception('An error occurred getting places nearby');
    }
  }

//5
  Future<dynamic> getTime(var origin, var destination) async {
    // Future.delayed(
    //const Duration(seconds: 2),
    // () async {
    //origin='miu cairo'; destination='guc' ;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key&language=en,ar&region=Eg'; //libraries=places &region=Eg

    var response = await http.get(Uri.parse(url));
    var y = "error";

    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);

      var results = json['routes'][0]['legs'][0]['duration']['text'];
      //json['routes'][0]['legs'][0]['distance'];
      //var results =  json['routes'][0]['legs'][0]['start_location']; "duration"

      print("the  duration is $results");
      //print ("Response body: ${response.body}");
      return await results;
      //return results.json['routes'][0]['legs'][0]['start_location'];

    } else {
      throw Exception('An error occurred getting places nearby');
      return y;
    }
  }
}
