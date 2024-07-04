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
                  child: Expanded(
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