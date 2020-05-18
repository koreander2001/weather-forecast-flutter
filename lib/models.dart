class Subdivision implements Comparable<Subdivision> {
  final String id;
  final String name;
  final String localName;

  Subdivision.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        localName = json['local_name'];

  @override
  String toString() => localName;

  @override
  int compareTo(Subdivision other) => id.compareTo(other.id);
}

class City implements Comparable<City> {
  final String id;
  final String name;
  final String localName;

  City.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        localName = json['local_name'];

  @override
  String toString() => localName;

  @override
  int compareTo(City other) => id.compareTo(other.id);
}

class WeatherForecast {
  final List<OneDayForecast> forecast;
  final ProviderLink provider;

  WeatherForecast.fromJson(Map<String, dynamic> json)
      : forecast = json['forecast'].map<OneDayForecast>((j) => OneDayForecast.fromJson(j)).toList(),
        provider = ProviderLink.fromJson(json['provider']);
}

class OneDayForecast implements Comparable<OneDayForecast> {
  final String date;
  final double precipProbability;
  final double temperatureHigh;
  final double temperatureLow;

  OneDayForecast.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        precipProbability = json['precipProbability'],
        temperatureHigh = json['temperatureHigh'],
        temperatureLow = json['temperatureLow'];

  @override
  int compareTo(OneDayForecast other) => date.compareTo(other.date);
}

class ProviderLink {
  final String message;
  final String link;

  ProviderLink.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        link = json['link'];
}
