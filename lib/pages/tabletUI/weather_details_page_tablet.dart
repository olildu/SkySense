import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/elements/tabletElements/weather_details_elements.dart';
import 'package:weather_app/elements/weather_details_elements.dart';

class WeatherDetailsPageTablet extends StatefulWidget {
  final String lat;
  final String lon;
  final String name;
  final SharedPreferences prefs;

  const WeatherDetailsPageTablet({super.key, 
    required this.lat, 
    required this.lon, 
    required this.prefs,
    required this.name
  });

  @override
  State<WeatherDetailsPageTablet> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPageTablet> {
  late Future<WeatherData> _weatherData;
  late Future<List<HourlyWeatherData>> _hourlyWeatherData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _weatherData = fetchWeatherData(widget.lat, widget.lon);
      _hourlyWeatherData = fetchHourlyWeatherData(widget.lat, widget.lon);
    });

    // await widget.prefs.setStringList('prevData', [widget.name, widget.lat, widget.lon]);
  }

  Future<WeatherData> fetchWeatherData(String lat, String lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=841171d30d4105b499bbd8726ffc5e70&units=metric';
    final response = await http.get(Uri.parse(url));

    return WeatherData.fromJson(jsonDecode(response.body));
  }

  Future<List<HourlyWeatherData>> fetchHourlyWeatherData(String lat, String lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=841171d30d4105b499bbd8726ffc5e70';
    final response = await http.get(Uri.parse(url));

    List<dynamic> data = jsonDecode(response.body)['list'];
    return data.map((json) => HourlyWeatherData.fromJson(json)).toList();
  }

  @override
Widget build(BuildContext context) {
  return AnnotatedRegion(
    value: SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    ),
    child: Scaffold(
      appBar: weatherDetailsAppBar(context, _weatherData),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<WeatherData>(
        future: _weatherData,
        builder: (context, snapshot) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          var squareSize = (height < width ? height : width) / 2;

          if (snapshot.hasData) {
            var weatherData = snapshot.data!;
            return Container(
              padding: EdgeInsets.all(height * 0.03),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(height * 0.03),
                      child: Container(
                        padding: EdgeInsets.all(height * 0.03),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: weatherMainIcon(context, MediaQuery.of(context).size, weatherData),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(height * 0.03),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(width * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 0),
                                        ),
                                      ),
                                      SizedBox(width: height > width? height * 0.01 : width * 0.01,),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(width * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 1),
                                        ),
                                      ),
                                      SizedBox(width: height > width? height * 0.01 : width * 0.01,),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(width * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height > width? height * 0.01 : width * 0.01,),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(height * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 3),
                                        ),
                                      ),
                                      SizedBox(width: height > width? height * 0.01 : width * 0.01,),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(height * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 4),
                                        ),
                                      ),
                                      SizedBox(width: height > width? height * 0.01 : width * 0.01,),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(width * 0.01),
                                          width: squareSize,
                                          height: squareSize,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: buildWeatherInfoContainer(height, weatherData, 5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(height * 0.03),
                            child: hourlyWeatherForecastTablet(_hourlyWeatherData, height, width),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load weather data',
                style: GoogleFonts.poppins(fontSize: 30),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    ),
  );
}

Widget buildWeatherInfoContainer(double height, WeatherData weatherData, int index) {
  String title;
  String value;
  IconData icon;

  switch (index) {
    case 0:
      title = "Wind";
      value = "${weatherData.windSpeed.round()} m/s";
      icon = Icons.air;
      break;
    case 1:
      title = "Pressure";
      value = "${weatherData.pressure}";
      icon = Icons.speed;
      break;
    case 2:
      title = "Feels Like";
      value = "${weatherData.feelsLike.round()}°C";
      icon = Icons.thermostat;
      break;
    case 3:
      title = "Humidity";
      value = "${weatherData.humidity}%";
      icon = Icons.water_drop;
      break;
    case 4:
      title = "Sea Level";
      value = "${weatherData.seaLevel}";
      icon = Icons.waves;
      break;
    case 5:
      title = "Ground";
      value = "${weatherData.groundLevel}";
      icon = Icons.terrain;
      break;
    default:
      title = "";
      value = "";
      icon = Icons.error_outline;
      break;
  }


  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(fontSize: height * 0.04),
      ),
      Expanded(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    child: index == 1 || index == 4 || index == 5
                    ? 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            style: GoogleFonts.poppins(fontSize: height * 0.05),
                          ),
                          Text(
                            index == 1 ? "hPa" : "m",
                            style: GoogleFonts.poppins(fontSize: height * 0.05),
                          ),
                        ],
                      )
                    : 
                    Text(
                        value,
                        style: GoogleFonts.poppins(fontSize: height * 0.05),
                    ),
                  ),
                ],
              ),
              Icon(icon, size: height * 0.08),
            ],
          ),
        ),
      ),
    ],
  );
}

}
