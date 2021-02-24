import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/services/Services.dart';
import 'package:madrasatymobile/main.dart';

class ProfileService extends Services {
  User user;
  StreamController<User> loggedInUserStream =
      StreamController.broadcast(sync: true);

  String country = Services.country;

  List<User> children = [];
  ProfileService() {}

  Future<int> setProfileData({
    User user,
    UserType userType,
  }) async {
    UserType userType = await sharedPreferencesHelper.getUserType();
    // String photoUrl = '';
    // String url = await sharedPreferencesHelper.getLoggedInUserPhotoUrl();

    // user.photoUrl = photoUrl;

    Map updatedUser = user.toJson();

    var body = json.encode(updatedUser);
    var userId = await sharedPreferencesHelper.getLoggedInUserId();

    String jwt = await storage.read(key: "jwt");
    final response = await put(
      server_ip + 'api/auth/update/' + user.id.toString(),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    if (response.statusCode == 200) {
      // getProfileData(user.id, userType);
      print("Data Uploaded Succesfully");
      final jsonData = await json.decode(response.body);

      User user = User.fromJson(jsonData);
      sharedPreferencesHelper.setUserDataModel(user);
      loggedInUserStream.add(user);
      return response.statusCode;
    } else {
      print("Data Upload error");
      print(response.statusCode);
      return response.statusCode;
    }
  }

  Future<User> getLoggedInUserProfileData() async {
    UserType userType = await sharedPreferencesHelper.getUserType();
    String userDataModel = await sharedPreferencesHelper.getUserDataModel();
    if (userDataModel != 'N.A') {
      print("Data Retrived Succesfully (local)");
      final jsonData = json.decode(userDataModel);
      // print(jsonData);
      User user = User.fromJson(jsonData);
      return user;
    }

    String jwt = await storage.read(key: "jwt");
    var userId = await sharedPreferencesHelper.getLoggedInUserId();

    final response = await get(
      server_ip + 'api/auth/get' + userId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      print("Data Retrived Succesfully");
      final jsonData = await json.decode(response.body);

      User user = User.fromJson(jsonData);
      sharedPreferencesHelper.setUserDataModel(user);
      loggedInUserStream.add(user);
      user.toString();
      return user;
    } else {
      print("Data Retrived failed");
      return User(id: userId);
    }
  }

  Future<User> getProfileDataById(int uid, UserType userType) async {
    var jwt = await storage.read(key: "jwt");
    var response = await get(
      server_ip + 'api/auth/get' + uid.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Authorization': jwt,
      },
    );
    print(response.headers);
    if (response.statusCode == 200) {
      print("user Retrived Succesfully");
      final jsonData = await json.decode(response.body);

      User user = User.fromJson(jsonData);
      return user;
    } else {
      print("Data Retrived failed");
      return User(id: uid);
    }
  }
}
