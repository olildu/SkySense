import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Shows icon based on the reponse from the API
Icon getWeatherIcon(String iconCode, double size) {
  switch (iconCode) {
    case '01d':
      return  Icon(Icons.wb_sunny, size: size, color: Colors.orange);
    case '01n':
      return  Icon(Icons.nightlight_round, size: size);
    case '02d':
    case '02n':
      return  Icon(Icons.cloud, size: size);
    case '03d':
    case '03n':
      return  Icon(Icons.cloud_circle, size: size);
    case '04d':
    case '04n':
      return  Icon(Icons.cloud_off, size: size);
    case '09d':
    case '09n':
      return  Icon(Icons.waves, size: size);
    case '10d':
    case '10n':
      return  Icon(Icons.waves, size: size, color: Colors.blue);
    case '11d':
    case '11n':
      return  Icon(Icons.flash_on, size: size);
    case '13d':
    case '13n':
      return  Icon(Icons.ac_unit, size: size);
    case '50d':
    case '50n':
      return  Icon(Icons.waves, size: size);
    default:
      return  Icon(Icons.wb_sunny, size: size, color: Colors.orange);
  }
}

// AppBar for weatherDetailsPage
AppBar weatherDetailsAppBar( BuildContext context, weatherData,){
  return AppBar(
    title: FutureBuilder<WeatherData>(
      future: weatherData,
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
  );
}

// Refresh button when clicked call fetchData function again and rebuilds the UI
FloatingActionButton refreshButton(Function fetchData){
  return FloatingActionButton( // Refresh button refresh data
    shape: const CircleBorder(),
    child: const Icon(Icons.refresh_rounded, color: Colors.white,),
    onPressed: () {
      fetchData(); // FetchData called again to get new data
    },
  );
}

// Main icon that shows weather condition in iconformat and as text
Widget weatherMainIcon(BuildContext context, screenSize, weatherData){
  return Column(
    children: [
      getWeatherIcon(weatherData.iconCode, 100), // Use dynamic weather icon

      SizedBox(height: screenSize.height * 0.03),

      // Text stating the weather condition
      Text(
        "${weatherData.temperature.round().toString()} °C",
        style: GoogleFonts.poppins( fontSize: screenSize.width * 0.1),
      ),

      SizedBox(height: screenSize.height * 0.01),
      
      // High and Low temperature of today
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "H: ${weatherData.temperatureMax.round().toString()} °C",
            style: GoogleFonts.poppins( fontSize: screenSize.width * 0.05),
          ),
          SizedBox(width: screenSize.height * 0.02),
          Text(
            "L: ${weatherData.temperatureMin.round().toString()} °C",
            style: GoogleFonts.poppins( fontSize: screenSize.width * 0.05),
          ),
        ],
      ),
    ],
  );
}

// Current condition widget with Humidity percentage, Wind speed, Pressure, Feels like
Widget currentConditions(BuildContext context, screenSize, weatherData) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: LayoutBuilder(
      builder: (context, constraints) {
        double itemSize = (constraints.maxWidth - 10) / 2; // Calculate item size

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Wind", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.05),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(weatherData.windSpeed.toString(), style: GoogleFonts.poppins(fontSize: screenSize.width * 0.08),),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(" m/s", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.03),)),
                              ],
                            ),
                            Icon(Icons.air, size: screenSize.width * 0.14),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pressure", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.05),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(weatherData.pressure.toString(), style: GoogleFonts.poppins(fontSize: screenSize.width * 0.08),),
                                Text(" mBar", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.03),),
                              ],
                            ),
                            Icon(Icons.speed, size: screenSize.width * 0.14),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Feels Like", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.05),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(weatherData.feelsLike.round().toString(), style: GoogleFonts.poppins(fontSize: screenSize.width * 0.1),),
                                Text(" °C", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.05),),
                              ],
                            ),
                            getWeatherIcon(weatherData.iconCode, 40)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Humidity", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.05),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(weatherData.humidity.toString(), style: GoogleFonts.poppins(fontSize: screenSize.width * 0.1),),
                                Text("%", style: GoogleFonts.poppins(fontSize: screenSize.width * 0.08),),
                              ],
                            ),
                            Icon(Icons.air, size: screenSize.width * 0.14),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}

// Text stating hourly forecast
Widget hourlyWeatherForecastText(){
  return Container(
    padding: const EdgeInsets.only(left: 3),
    alignment: Alignment.centerLeft, child: Text("Hourly Forecast", style: GoogleFonts.poppins(fontSize: 18),
    )
  );
}

// Text stating current conditions
Widget cuurentConditionsText(){
  return Container(
    padding: const EdgeInsets.only(left: 10),
    alignment: Alignment.centerLeft, child: Text("Current Conditions", style: GoogleFonts.poppins(fontSize: 18),
    )
  );
}

// Widget showing hourly forecast data
Widget hourlyWeatherForecast(Future<List<HourlyWeatherData>> hourlyWeatherData) {
  return FutureBuilder<List<HourlyWeatherData>>(
    future: hourlyWeatherData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var hourlyData = snapshot.data!.sublist(0,9); // Only 10 datas are taken 
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)
          ),
          height: 120, // Adjusted height to accommodate the time text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              var data = hourlyData[index];
              return SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${data.temperature.round()} °C",
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    const SizedBox(height: 5),

                    getWeatherIcon(data.iconCode, 30),

                    const SizedBox(height: 5),
                    Text(
                      index == 0 ? "Now" : "${data.time.hour}:${data.time.minute.toString().padLeft(2, '0')}", // Displaying the forecast time
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else if (snapshot.hasError) {
        return const Text(
          'Failed to load hourly forecast',
          style: TextStyle(),
        );
      }
      return const CircularProgressIndicator();
    },
  );
}

// Class to handle HourlyWeatherData recieved from the API
class HourlyWeatherData {
  final DateTime time;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final String weatherCondition;
  final String iconCode;

  HourlyWeatherData({
    required this.time,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.weatherCondition,
    required this.iconCode,
  });

  factory HourlyWeatherData.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherData(
      time: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
      temperatureMin: json['main']['temp_min'].toDouble(),
      temperatureMax: json['main']['temp_max'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}

// Class to handle WeatherData recieved from the API
class WeatherData {
  final String cityName;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final String weatherCondition;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final double feelsLike;
  final int pressure;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.weatherCondition,
    required this.humidity,
    required this.pressure,
    required this.feelsLike,
    required this.windSpeed,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      temperatureMin: json['main']['temp_min'].toDouble(),
      temperatureMax: json['main']['temp_max'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      feelsLike: json['main']['feels_like'],
      pressure: json['main']['pressure'],
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}