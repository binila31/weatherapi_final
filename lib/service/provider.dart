import 'package:flutter/material.dart';

import 'package:weatherapi_final/service/api_endpoints.dart';
import '../model/weather.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather(double latitude, double longitude) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;


      final response = await http.get(Uri.parse(ApiEndpoints.weatherUrl(latitude, longitude)));
      print("Latitude: $latitude");
      print("Longitude: $longitude");
      if (response.statusCode == 200) {
        _weather = Weather.fromJson(json.decode(response.body));
      } else {
        _error = 'Failed to load weather data';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

}

