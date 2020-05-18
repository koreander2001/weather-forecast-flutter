import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';
import 'models.dart';
import 'widgets/dynamic_dropdown_button.dart';
import 'widgets/dynamic_weather_forecast_table.dart';

class HomePage extends StatelessWidget {
  final String pageTitle = '天気予報';

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Bloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Column(
          children: <Widget>[
            DynamicDropdownButton<Subdivision>(
              getItemsStream: bloc.getSubdivisions,
              holdingItemStream: bloc.holdingSubdivision,
              hint: '都道府県を選択してください',
              onChanged: (Subdivision subdivision) {
                bloc.changeSubdivision.add(subdivision);
                bloc.requestCities.add(subdivision);
              },
              widgetsWhenNoData: CircularProgressIndicator(),
            ),
            DynamicDropdownButton<City>(
              getItemsStream: bloc.getCities,
              holdingItemStream: bloc.holdingCity,
              hint: '市区町村を選択してください',
              onChanged: (City city) {
                bloc.changeCity.add(city);
                bloc.requestForecast.add(city);
              },
              widgetsWhenNoData: Container(),
            ),
            DynamicWeatherForecastTable(
              getForecastStream: bloc.getForecast,
              widgetsWhenNoData: Container(),
            )
          ],
        )
    );
  }
}
