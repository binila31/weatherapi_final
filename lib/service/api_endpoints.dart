class ApiEndpoints {
  static const String weatherApiKey = '39413750ef4e3dd48f21f150c2a18dc7';

  static String weatherUrl(double latitude, double longitude) {
    return 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=metric';
  }
}
