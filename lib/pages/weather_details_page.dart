import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/elements/weather_details_elements.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String lat;
  final String lon;
  final String name;
  final SharedPreferences prefs;

   const WeatherDetailsPage({super.key, required this.lat, required this.lon, required this.prefs, required this.name});

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  late Future<WeatherData> _weatherData;
  late Future<List<HourlyWeatherData>> _hourlyWeatherData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async { // Fetch data and rebuild
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
    Size screenSize = MediaQuery.of(context).size; // ScreenSize is taken in account for responsive designs

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface // For maintaing color on statusBar
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton( // Refresh button refresh data
          shape: const CircleBorder(),
          child: const Icon(Icons.refresh_rounded, color: Colors.white,),
          onPressed: () {
            _fetchData(); // FetchData called again to get new data
          },
        ),
        appBar: AppBar(
          title: FutureBuilder<WeatherData>(
            future: _weatherData,
            builder: (context, snapshot) { // Set city name as appBar title 
              if (snapshot.hasData) {
                var weatherData = snapshot.data!;
                return Text(
                  weatherData.cityName,
                  style: GoogleFonts.poppins(),
                );
              } else if (snapshot.hasError) { // Error handling implemented
                return Text(
                  'Weather Details',
                  style: GoogleFonts.poppins(),
                );
              }
              return Text( // Text shown when loading
                'Loading...',
                style: GoogleFonts.poppins(),
              );
            },
          ),
          centerTitle: true, // Centred title
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded, ), // Arrow to go back to HomePage
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),

        backgroundColor: Theme.of(context).colorScheme.surface,
        body: FutureBuilder<WeatherData>( // Future builder used to show loading to the uyser
          future: _weatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var weatherData = snapshot.data!; // Data loaded to this variable
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.05),

                        // Main icon that shows weather condition in icon format and as text with high and low temperature today
                        weatherMainIcon(context, screenSize, weatherData),

                        SizedBox(height: screenSize.height * 0.07),

                        // Text stating current conditions
                        cuurentConditionsText(),

                        SizedBox(height: screenSize.height * 0.01),

                        // Current condition widget with Humidity percentage, Wind speed, Pressure, Feels like
                        currentConditions(context, screenSize, weatherData),

                        SizedBox(height: screenSize.height * 0.03),

                        // Text stating hourly forecast
                        hourlyWeatherForecastText(),

                        SizedBox(height: screenSize.height * 0.01),
                        
                        // Widget showing hourly forecast data
                        hourlyWeatherForecast(_hourlyWeatherData),
                      
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) { // Error handling implemented
              return const Center(
                child: Text(
                  'Failed to load weather data',
                  style: TextStyle(),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator()); // Shows user loading if data hasnt loaded yet
          },
        ),
      ),
    );
  }
}