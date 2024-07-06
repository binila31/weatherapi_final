class Weather {
  final String location;
  final String description;
  final double temperature;
  final double feelsLike;
  final int humidity;

  Weather({
    required this.location,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}
