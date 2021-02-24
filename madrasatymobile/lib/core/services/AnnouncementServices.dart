import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'dart:convert';
import 'package:madrasatymobile/core/services/Services.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:madrasatymobile/main.dart';
import 'package:path/path.dart' as p;

class AnnouncementServices extends Services {
  User user;
  List<Announcement> announcements = new List<Announcement>();

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  Future<List<Announcement>> getAnnouncements() async {
    var userDataModel = await _sharedPreferencesHelper.getUserDataModel();
    final jsonData = json.decode(userDataModel);
    user = User.fromJson(jsonData);

    var jwt = await storage.read(key: "jwt");
    final Response response = await get(
      server_ip + 'api/announcement/' + user.divisionId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    // print(response.headers);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body).cast<Map<String, dynamic>>();
      announcements =
          res.map<Announcement>((json) => Announcement.fromJson(json)).toList();

      return announcements;
    } else {
      return [];
    }
  }

  Future<int> postAnnouncement(Announcement announcement) async {
    Map data = {
      "UserId": announcement.userId,
      "Caption": announcement.caption,
      "UserPhotoUrl": announcement.userPhotoUrl,
      "DisplayName": announcement.displayName,
      "DivisionId": announcement.divisionId,
      "StandardId": announcement.standardId,
      "TimeStamp": announcement.timestamp,
      "PhotoUrl": announcement.photoUrl,
      "AnnouncementType": announcement.anouncementType
    };
    // print(data);
    String jwt = await storage.read(key: "jwt");

    final Response response = await post(
      server_ip + 'api/announcement/',
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );

    return response.statusCode;
  }
}
