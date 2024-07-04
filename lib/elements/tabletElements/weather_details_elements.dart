import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/elements/weather_details_elements.dart';

Widget hourlyWeatherForecastTablet(Future<List<HourlyWeatherData>> hourlyWeatherData, height, width) {
  return FutureBuilder<List<HourlyWeatherData>>(
    future: hourlyWeatherData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var hourlyData = snapshot.data!.sublist(0,9); // Only 10 datas are taken 
        return Container(
          padding: EdgeInsets.all(height * 0.01),
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
                width: (width * 0.067),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  ),
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
