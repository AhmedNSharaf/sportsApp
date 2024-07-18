import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sports_app/data/models/CountriesData.dart';
import 'package:sports_app/data/reposetories/CountriesRepo.dart';
import 'package:sports_app/screens/leagusScreen.dart';
import 'package:sports_app/utils/colors.dart';

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  late Future<CountriesData> futureCountriesData;
  Position? _currentPosition;
  String? _currentCountryName;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureCountriesData = CountriesRepo().fetchCountriesData();
  }

  Future<void> _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission is denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    // Assuming you have a method to get the country name based on the position
    String countryName = await _getCountryNameFromPosition(position);
    setState(() {
      _currentCountryName = countryName;
    });

    _scrollToCountry(countryName);
  }

  Future<String> _getCountryNameFromPosition(Position position) async {
    // Implement logic to determine the country name based on position
    // For simplicity, returning a placeholder value here
    return "CountryName"; // Replace with actual country name
  }

  void _scrollToCountry(String countryName) {
    // Implement logic to scroll to the specific country in the grid
    // Placeholder implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: secondaryColor),
            onPressed: _getCurrentLocation,
          ),
        ],
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Countries',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<CountriesData>(
        future: futureCountriesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load countries data'));
          } else if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
            return Center(child: Text('No countries available'));
          } else {
            return Column(
              children: [
                if (_currentPosition != null && _currentCountryName != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Current Location: $_currentCountryName',
                      style: TextStyle(
                          color: secondaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.2 / 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: EdgeInsets.all(5),
                    itemCount: snapshot.data!.result.length,
                    itemBuilder: (context, index) {
                      var country = snapshot.data!.result[index];
                      bool isCurrentCountry =
                          country.countryName == _currentCountryName;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LeaguesScreen(countryKey: country.countryKey),
                            ),
                          );
                        },
                        child: Card(
                          color: isCurrentCountry ? Colors.amber : thirdColor,
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (country.countryLogo != null &&
                                  country.countryLogo!.isNotEmpty)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      country.countryLogo!,
                                      height: 50,
                                      width: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: secondaryColor);
                                      },
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                              else
                                Icon(Icons.flag,
                                    color: secondaryColor, size: 50),
                              Text(
                                country.countryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
