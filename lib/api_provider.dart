import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

class ApiProvider {
  final String _baseUrl = DotEnv().env['WEATHER_FORECAST_API_URL'];

  Future<List<Subdivision>> getSubdivisions() async {
    final String url = '$_baseUrl/region/subdivisions/';
    final http.Response response = await http.get(url);
    final String responseBody = utf8.decode(response.bodyBytes);

    final List jsonList = jsonDecode(responseBody);
    final List subdivisions = jsonList.map((j) => Subdivision.fromJson(j)).toList();
    subdivisions.sort();
    return subdivisions;
  }

  Future<List<City>> getCities(String subdivisionId) async {
    final String url = '$_baseUrl/region/cities/?subdivision=$subdivisionId';
    final http.Response response = await http.get(url);
    final String responseBody = utf8.decode(response.bodyBytes);

    final List jsonList = jsonDecode(responseBody);
    final List cities = jsonList.map((j) => City.fromJson(j)).toList();
    cities.sort();
    return cities;
  }

  Future<WeatherForecast> getForecast(String cityId) async {
    final String url = '$_baseUrl/forecast/$cityId/';
    final http.Response response = await http.get(url);
    final String responseBody = utf8.decode(response.bodyBytes);

    final Map jsonMap = jsonDecode(responseBody);
    final weatherForecast = WeatherForecast.fromJson(jsonMap);
    weatherForecast.forecast.sort();
    return weatherForecast;
  }
}
