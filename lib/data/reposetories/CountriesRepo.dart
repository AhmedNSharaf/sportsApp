import 'package:dio/dio.dart';
import 'package:sports_app/data/models/CountriesData.dart';

class CountriesRepo {
  Dio dio = Dio();

  Future<CountriesData> fetchCountriesData() async {
    var response = await dio.get(
      'https://apiv2.allsportsapi.com/football/?met=Countries&APIkey=4dbd8cf7eeee81d13356a42a98b66173295d491fdeaa4434e4a93d64b13a447b',
    );

    if (response.statusCode == 200) {
      return CountriesData.fromJson(response.data);
    } else {
      throw Exception('Failed to load countries data');
    }
  }
}
