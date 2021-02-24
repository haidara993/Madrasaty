import 'package:madrasatymobile/core/Models/holiday_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:world_holidays/internal/keys.dart';

class CalendarificApiCall {
  String apiKey =
      'ce228b7cc7c23504ccf5aa78b43ef8f4ef7ff041'; //API key from calendarific.com :)
  String currentYear = DateTime.now().year.toString();

  Future<HolidayData> getHolidays(String countryCode) async {
    final response = await http.get(
        'https://calendarific.com/api/v2/holidays?country=SY&year=$currentYear&api_key=$apiKey');
    if (response.statusCode == 200) {
      final jsonData = await json.decode(response.body);
      return HolidayData.fromJson(jsonData);
    } else {
      throw Exception("Failed to get holidays");
    }
  }
}
