import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/pages/weather_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController(); // Controller for textField
  List<String> suggestions = []; // Suggestions list for getting suggestions when user searches (Auto Complete)
  List<dynamic> locationData = []; // LocationData list for properly ensuring user is routed correctly
  List prevData = []; // prevData list to load previous user data and also is saved to the disk for persistance
  Timer? _debounce; // Timer to ensure API call is not spammed
  late SharedPreferences prefs; // SharedPreferences 

  // Request geolocation based on city or country name (also has auto complete feature)
  Future<void> fetchSuggestions(String query) async {
    final Uri url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=jsonv2&accept-language=en&limit=3');
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) { // Proper error handling is implemented and notifying the user 
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        locationData.clear(); // Clear all lists when new search started
        suggestions.clear();

        locationData.addAll(data); // Once clear is completed then data is mapped to these list
        suggestions.addAll(data.map((dynamic fullData) => fullData['display_name'] as String).toList());
      });
    } else {
      throw Exception('Failed to load suggestions'); // Error Handling in place
    }
  }

  // Function to listen to textField so as to call FetchSuggestions
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // debounce so as to fetchSuggestions is not spammed 
    _debounce = Timer(const Duration(milliseconds: 700), () { // timer of 700ms will run and if no input has been detected then fetchSuggestions is executed
      if (controller.text.isNotEmpty) { // If textfield not empty then fetchSuggestions
        fetchSuggestions(controller.text);
      } else {
        setState(() {
          suggestions.clear(); // If textfield empty then clear suggestions
        });
      }
    });
  }
  // Initialize Preferences
  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance(); // Init
    setState(() { // Call setState so as to rebuild the UI
      prevData = prefs.getStringList("prevData") as List; // Save as list to prevData data is saved in the format of ["name", "lat", "lon"]
    });
  }

  @override
  void initState() { // Functions to load on start
    super.initState();
    controller.addListener(_onSearchChanged); // Listen to every change in TextField (aids in the search functionality)
    initializeSharedPreferences(); // Initialize shared preferences for using prevData saved in localDisk 
  }

  @override
  void dispose() { // Dispose all listening items and free them
    controller.removeListener(_onSearchChanged);
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WeatherAPP',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true, // Center title
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
     
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField for taking city name and other details
            TextField(
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
            ),

            const SizedBox(height: 16),

            // This if statement checks if the user has any previous data store and if 
            //  - True: Then shows the previous data
            //  - False: Then skips this entire code            
            if(prevData.isNotEmpty)...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // All data aligns to the left most
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
                          builder: (context) => WeatherDetailsPage(
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
              )
            ],
      
            const SizedBox(height: 16),
      
            // This if statements checks if statements list is not empty if
            //  - True: Then shows the suggested data
            //  - False: Then skips this entire code     
            if (suggestions.isNotEmpty)...[
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
            ]
          ],
        ),
      ),
    );
  }
}
