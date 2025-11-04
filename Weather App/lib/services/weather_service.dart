import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<String> _getLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Konum servisiniz kapalı");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Konum izni vermelisiniz");
      }
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final String? city = placemark[0].administrativeArea;

    if (city == null) return Future.error("Sehir bulunamadi");

    return city.toLowerCase();
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await _getLocation();

    print("BULUNAN SEHIR: $city");

    final String url =
        "https://api.collectapi.com/weather/getWeather?lang=tr&city=$city";

    const Map<String, String> headers = {
      "authorization": "apikey 3OiMFipKYPBNLwzNXaKtKB:6SVZrnOJthAaCj7gTcfP1x",
      "content-type": "application/json",
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      throw Exception("API Hatasi");
    }

    final List list = response.data as List;

    final List<WeatherModel> weatherList = [];

    for (var item in list) {
      weatherList.add(WeatherModel.fromJson(item));
    }

    return weatherList;
  }
}
