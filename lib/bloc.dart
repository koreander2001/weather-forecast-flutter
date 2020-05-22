import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'api_provider.dart';
import 'models.dart';

class Bloc {
  final apiProvider = ApiProvider();

  final _resultSubdivisionsController = BehaviorSubject<List<Subdivision>>();
  final _holdingSubdivisionController = BehaviorSubject<Subdivision>.seeded(null);
  StreamSink<List<Subdivision>> get _inResultSubdivisions => _resultSubdivisionsController.sink;
  Stream<List<Subdivision>> get getSubdivisions => _resultSubdivisionsController.stream;
  StreamSink<Subdivision> get changeSubdivision => _holdingSubdivisionController.sink;
  Stream<Subdivision> get holdingSubdivision => _holdingSubdivisionController.stream;

  final _requestCitiesController = PublishSubject<Subdivision>();
  final _resultCitiesController = BehaviorSubject<List<City>>();
  final _holdingCityController = BehaviorSubject<City>.seeded(null);
  StreamSink<Subdivision> get requestCities => _requestCitiesController.sink;
  Stream<Subdivision> get _outRequestCities => _requestCitiesController.stream;
  StreamSink<List<City>> get _inResultCities => _resultCitiesController.sink;
  Stream<List<City>> get getCities => _resultCitiesController.stream;
  StreamSink<City> get changeCity => _holdingCityController.sink;
  Stream<City> get holdingCity => _holdingCityController.stream;

  final _requestForecastController = PublishSubject<City>();
  final _resultForecastController = BehaviorSubject<WeatherForecast>.seeded(null);
  StreamSink<City> get requestForecast => _requestForecastController.sink;
  Stream<City> get _outRequestForecast => _requestForecastController.stream;
  StreamSink<WeatherForecast> get _inResultForecast => _resultForecastController.sink;
  Stream<WeatherForecast> get getForecast => _resultForecastController.stream;

  Bloc() {
    _outRequestCities.listen(_requestCities);

    _outRequestForecast.listen(_requestForecast);

    _requestSubdivisions();

    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('subdivision')) {
      final subdivisionJson = jsonDecode(prefs.getString('subdivision'));
      final subdivision = Subdivision.fromJson(subdivisionJson);
      changeSubdivision.add(subdivision);
      requestCities.add(subdivision);

      if (prefs.containsKey('city')) {
        final cityJson = jsonDecode(prefs.getString('city'));
        final city = City.fromJson(cityJson);
        changeCity.add(city);
        requestForecast.add(city);
      }
    }
  }

  void _requestSubdivisions() {
    apiProvider.getSubdivisions()
        .then(_inResultSubdivisions.add)
        .catchError((err) => _inResultSubdivisions.addError('Failed to get subdivisions'));
  }

  Future<void> _requestCities(Subdivision subdivision) async {
    apiProvider.getCities(subdivision.id)
        .then(_inResultCities.add)
        .catchError((err) => _inResultCities.addError('Failed to get cities'));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subdivision', jsonEncode(subdivision.toJson()));
  }

  Future<void> _requestForecast(City city) async {
    apiProvider.getForecast(city.id)
        .then(_inResultForecast.add)
        .catchError((err) => _inResultForecast.addError('Failed to get forecast'));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', jsonEncode(city.toJson()));
  }

  void dispose() {
    _resultSubdivisionsController.close();
    _holdingSubdivisionController.close();

    _requestCitiesController.close();
    _resultCitiesController.close();
    _holdingCityController.close();

    _requestForecastController.close();
    _resultForecastController.close();
  }
}