import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';
import 'home_page.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(WeatherForecastApp());
}

class WeatherForecastApp extends StatelessWidget {
  final String appTitle = '天気予報';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider(
        create: (context) => Bloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: HomePage(),
      ),
    );
  }
}
