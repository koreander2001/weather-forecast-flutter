import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';

class DynamicWeatherForecastTable extends StatelessWidget {
  final Stream<WeatherForecast> getForecastStream;
  final Widget widgetsWhenNoData;

  DynamicWeatherForecastTable({
    Key key,
    this.getForecastStream,
    this.widgetsWhenNoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    return StreamBuilder(
      stream: getForecastStream,
      builder: (BuildContext context, AsyncSnapshot<WeatherForecast> snapshot)
    {
      if (snapshot.hasData) {
        return Column(
          children: <Widget>[
              DataTable(
                dataRowHeight: queryData.size.height / 14,
                columnSpacing: queryData.size.width / 16,
                columns: _createTableHeader(),
                rows: snapshot.data.forecast.map((forecast) {
                  return _createOneRow(forecast, queryData.size.width / 6);
                }).toList(),
              ),
            _createProviderText(snapshot.data.provider),
          ],
        );
      } else if (snapshot.hasError) {
        return Text('error: ${snapshot.error}');
      }else {
          return widgetsWhenNoData;
        }
      },
    );
  }

  List<DataColumn> _createTableHeader() {
    List<String> headers = ['', '降水確率', '最高気温', '最低気温'];
    return headers.map((label) {
      return DataColumn(label: Text(label));
    }).toList();
  }

  DataRow _createOneRow(OneDayForecast forecast, double width) {
    final List<String> texts = [
      DateFormat('MM/dd').format(DateTime.parse(forecast.date)),
      (forecast.precipProbability * 100).toStringAsFixed(0) + ' %',
      forecast.temperatureHigh.toStringAsFixed(0) + ' °C',
      forecast.temperatureLow.toStringAsFixed(0) + ' °C',
    ];
    return DataRow(
        cells: texts.map((text) => DataCell(Container(width: width, child: Text(text)))).toList()
    );
  }

  Text _createProviderText(ProviderLink provider) {
    return Text('${provider.message} (${provider.link})');
  }
}
