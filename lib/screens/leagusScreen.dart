import 'package:flutter/material.dart';
import 'package:sports_app/data/models/LeagueData.dart';
import 'package:sports_app/data/reposetories/LeagusRepo.dart';
import 'package:sports_app/utils/colors.dart';

class LeaguesScreen extends StatefulWidget {
  final int countryKey;

  LeaguesScreen({required this.countryKey});

  @override
  _LeaguesScreenState createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  late Future<LeagueData> futureLeaguesData;

  @override
  void initState() {
    super.initState();
    futureLeaguesData = LeaguesRepo().fetchLeaguesData(widget.countryKey);
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
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Leagues',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<LeagueData>(
        future: futureLeaguesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load leagues data'));
          } else if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
            return Center(child: Text('No leagues available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.2 / 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.all(5),
              itemCount: snapshot.data!.result.length,
              itemBuilder: (context, index) {
                var league = snapshot.data!.result[index];
                return Card(
                  color: thirdColor,
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (league.leagueLogo != null && league.leagueLogo!.isNotEmpty)
                        Image.network(
                          league.leagueLogo!,
                          height: 50,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: secondaryColor);
                          },
                        )
                      else
                        Icon(Icons.sports_soccer, color: secondaryColor, size: 50),
                      SizedBox(height: 10),
                      Text(
                        league.leagueName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
