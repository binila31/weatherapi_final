import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service/provider.dart';
import 'views/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        home: WeatherScreen(),
      ),
    );
  }
}
