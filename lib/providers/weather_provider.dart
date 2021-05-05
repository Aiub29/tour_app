import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tour_app/models/ForecastModel.dart';
import 'package:tour_app/models/current_model.dart';
import 'package:http/http.dart' as Http;
import 'package:geolocator/geolocator.dart' as Geo;


class WeatherProvider with ChangeNotifier{
  CurrentWeatherResponse _currentWeatherResponse;
  ForeCastWeatherResponse _foreCastWeatherResponse;
  CurrentWeatherResponse get currentData => _currentWeatherResponse;
  ForeCastWeatherResponse get forecastData => _foreCastWeatherResponse;

  Future getCurrentWeatherInfo(Geo.Position position) async {
    final url = 'api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=51b8dad691e9267a93223b20048e724a';
    try{
      final response = await Http.get(url);
      final map=json.decode(response.body);
      _foreCastWeatherResponse = ForeCastWeatherResponse.fromJson(map);
      //print('temp: ${_currentWeatherResponse.main.temp}');
      notifyListeners();
    }
    catch(error){
     throw error;
    }
  }

  Future getForecastWeatherInfo(Geo.Position position) async {
    final url = 'http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=51b8dad691e9267a93223b20048e724a';
    try{
      final response = await Http.get(url);
      final map=json.decode(response.body);
      _currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
      //print('temp: ${_currentWeatherResponse.main.temp}');
      notifyListeners();
    }
    catch(error){
     throw error;
    }
  }
}