import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/pages/mobileUI/weather_details_page.dart';
import 'package:weather_app/pages/tabletUI/weather_details_page_tablet.dart';
import 'package:weather_app/responsive/responsive.dart';

// App bar for homePage 
AppBar homePageAppBar(BuildContext context){
  return AppBar(
    title: Text(
      'SkySense',
      style: GoogleFonts.poppins(),
    ),
    centerTitle: true, // Center title
    backgroundColor: Theme.of(context).colorScheme.surface,
  );
}

// SearchBar for cities search
TextField searchBar(TextEditingController controller){
  return TextField(
    style: GoogleFonts.poppins(), // Styled Fonts
    controller: controller,
    decoration: InputDecoration(
      hintText: 'Enter a city', // Prefix
      hintStyle: GoogleFonts.poppins(),
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}

// Widget to load previous data stored in localStorage
Widget previousDataUI(BuildContext context, List prevData, SharedPreferences prefs) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title stating Saved Previous Data
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "Saved Previous Data",
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),

      // Wrapped with GestureDetector for pageNavigation
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveLayout( // Using responsive layout to figure out when to use mobileLayout vs tabletLayout
                mobileBody: WeatherDetailsPage(
                  lat: prevData[1], // Assuming prevData contains necessary data
                  lon: prevData[2],
                  name: prevData[0],
                  prefs: prefs,
                ),
                tabletBody: WeatherDetailsPageTablet(
                  lat: prevData[1],
                  lon: prevData[2],
                  name: prevData[0],
                  prefs: prefs,
                ),
              ),
            ),
          );
        },
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 50, 129, 220),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on_outlined),
            ),
            title: Text(prevData[0], style: GoogleFonts.poppins()),
          ),
        ),
      ),
    ],
  );
}

// Widget to load data stored from suggestions
Widget suggestionDataUI(List suggestions, List locationData, SharedPreferences prefs,Function initializeSharedPreferences){
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title stating Saved Search Data
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Search Data", style: GoogleFonts.poppins(fontSize: 20),),
        ),
    
        // Building cards from suggested dataa
        Expanded(
          child: ListView.builder( // ListView builder to access index and to achieve scrollability function
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).colorScheme.primary,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Container( // Location pin Icon is built here
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 50, 129, 220),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.location_on_outlined),
                  ),
                  title: Text(suggestions[index], style: GoogleFonts.poppins()),
                  onTap: () { // OnTap for page navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponsiveLayout(
                          mobileBody: WeatherDetailsPage(
                            lat: locationData[index]["lat"], // Take data and route to page
                            lon: locationData[index]["lon"],
                            name: locationData[index]["display_name"],
                            prefs: prefs,
                          ),
                          tabletBody: WeatherDetailsPageTablet(
                            lat: locationData[index]["lat"],
                            lon: locationData[index]["lon"],
                            name: locationData[index]["display_name"],
                            prefs: prefs,
                          ),
                        ),
                      ),
                    ).then((e){
                      initializeSharedPreferences(); // Reload the prev data again after this page recieves focus again
                    }
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
