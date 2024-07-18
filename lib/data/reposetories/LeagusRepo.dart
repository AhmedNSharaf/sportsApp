import 'package:dio/dio.dart';
import 'package:sports_app/data/models/LeagueData.dart';

class LeaguesRepo {
  final Dio dio = Dio();

  Future<LeagueData> fetchLeaguesData(int countryKey) async {
    try {
      final response = await dio.get(
        'https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=4dbd8cf7eeee81d13356a42a98b66173295d491fdeaa4434e4a93d64b13a447b&countryId=$countryKey'
      );
      if (response.statusCode == 200) {
        return LeagueData.fromJson(response.data);
      } else {
        throw Exception('Failed to load leagues data');
      }
    } catch (e) {
      throw Exception('Failed to load leagues data: $e');
    }
  }
}
