import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../service/provider.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    _determinePosition() .then((position) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(position.latitude, position.longitude);
    });
  }

  Future<Position> _determinePosition()  async {
    final serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return CircularProgressIndicator();
            } else if (provider.error != null) {
              return Text(
                'Error: ${provider.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              );
            } else if (provider.weather == null) {
              return CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.weather!.location,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    provider.weather!.description,
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${provider.weather!.temperature}°C',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Feels like: ${provider.weather!.feelsLike}°C',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Humidity: ${provider.weather!.humidity}%',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _determinePosition() .then((position) {
                        provider.fetchWeather(
                            position.latitude, position.longitude);
                      });
                    },
                    child: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
