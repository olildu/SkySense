import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/pages/mobileUI/weather_details_page.dart';
import 'package:weather_app/pages/tabletUI/weather_details_page_tablet.dart';

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
    style: GoogleFonts.poppins(),
    controller: controller,
    decoration: InputDecoration(
      hintText: 'Enter a city',
      hintStyle: GoogleFonts.poppins(),
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}

// Widget to load previous data stored in localStorage
Widget previousDataUI(BuildContext context, List prevData, SharedPreferences prefs){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title stating Saved Previous Data
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text("Saved Previous Data", style: GoogleFonts.poppins(fontSize: 20),),
      ),

      // Wrapped with gestureDetector for pageNavigation
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherDetailsPageTablet(
                lat: prevData[1], // Access data from prevData using indexes
                lon: prevData[2],
                prefs: prefs,
                name: prevData[0]
              )
            ),
          );
        },
        // Build card with data from prevData
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Container( // Location pin Icon is built here
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 50, 129, 220),
                  shape: BoxShape.circle
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
                        builder: (context) => WeatherDetailsPage(
                          lat: locationData[index]["lat"],
                          lon: locationData[index]["lon"],
                          prefs: prefs,
                          name: locationData[index]["display_name"]
                          // lon: locationData[index]["displayName"]
                        )
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