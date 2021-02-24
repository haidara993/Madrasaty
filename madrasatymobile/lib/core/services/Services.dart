import 'dart:io';

import 'package:madrasatymobile/core/Models/LoginUser.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/locator.dart';

class Services {
  final String apiUrl = "http://10.0.2.2:5000/";
  SharedPreferencesHelper sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  static String country = "Syria";

  User _user;

  LoginUser loginUser;

  String schoolCode = null;

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': "*/*",
    'connection': 'keep-alive',
    'Accept-Encoding': 'gzip, deflate, br',
  };
}
