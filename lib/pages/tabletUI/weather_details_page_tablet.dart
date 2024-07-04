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

  Future<void> fetchData() async { // Fetch data and rebuild
    setState(() {
      _weatherData = fetchWeatherData(widget.lat, widget.lon);
      _hourlyWeatherData = fetchHourlyWeatherData(widget.lat, widget.lon);
    });
    
    // Whenever data is fetched then the data is writted to the disk to ensure that the user can access it the next time 
    await widget.prefs.setStringList('prevData', [widget.name, widget.lat, widget.lon]);
  }

  // OpenWeatherMap API calls and is then passed to WeatherData class to process the JSON recieved (Used for current time data)
  Future<WeatherData> fetchWeatherData(String lat, String lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=841171d30d4105b499bbd8726ffc5e70&units=metric';
    final response = await http.get(Uri.parse(url));

    return WeatherData.fromJson(jsonDecode(response.body));
  }

  // OpenWeatherMap API calls and is then passed to HourlyWeatherData class to process the JSON recieved (Used for hourly data)
  Future<List<HourlyWeatherData>> fetchHourlyWeatherData(String lat, String lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=841171d30d4105b499bbd8726ffc5e70';
    final response = await http.get(Uri.parse(url));

      List<dynamic> data = jsonDecode(response.body)['list'];
      return data.map((json) => HourlyWeatherData.fromJson(json)).toList(); // Data is sent to class
  }

  @override
Widget build(BuildContext context) {
  return AnnotatedRegion(
    value: SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    ),
    child: Scaffold(
      floatingActionButton: refreshButton(fetchData),
      appBar: weatherDetailsAppBar(context, _weatherData),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<WeatherData>(
        future: _weatherData,
        builder: (context, snapshot) {
          // Variables used for responsive layout building
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
                  // Main weather icon with high and low temperature
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
                        child: weatherMainIcon(context, height, weatherData),
                      ),
                    ),
                  ),

                  // Current conditions temperature
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
                                          padding: EdgeInsets.all(height * 0.01),
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
                                          padding: EdgeInsets.all(height * 0.01),
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
                                          padding: EdgeInsets.all(height * 0.01),
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
                                          padding: EdgeInsets.all(height * 0.01),
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

                        // Hourly forecast Widget
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
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    ),
  );
}
}
