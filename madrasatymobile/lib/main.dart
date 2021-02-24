import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:madrasatymobile/UI/pages/Home.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/AuthService.dart';
import 'package:madrasatymobile/core/services/ProfileService.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:provider/provider.dart';

import 'UI/Utility/constants.dart';
import 'UI/pages/LoginPage.dart';

const server_ip = 'http://10.0.2.2:5000/';
final storage = FlutterSecureStorage();
void main() {
  Provider.debugCheckInvalidValueType = null;
  setupLocator();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // User user;
  SharedPreferencesHelper sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  Future<String> get jwtOrEmpty async {
    // sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
    //   final jsonData = json.decode(userDataModel);
    //   user = User.fromJson(jsonData);
    // });
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          initialData: User(),
          value: locator<ProfileService>().loggedInUserStream.stream,
        ),
        StreamProvider<bool>.value(
          initialData: false,
          value: locator<AuthService>().isUserLoggedInStream.stream,
        ),
        StreamProvider<UserType>.value(
          initialData: UserType.Unkown,
          value: locator<AuthService>().userTypeStream.stream,
        )
      ],
      child: MaterialApp(
        title: 'Madrasaty',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
          primaryColorDark: Color(0xff0029cb),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: jwtOrEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return kBuzyPage(color: Theme.of(context).accentColor);
              if (snapshot.data != "") {
                var str = snapshot.data;
                var jwt = str.split(".");

                if (jwt.length != 3) {
                  return LoginPage();
                } else {
                  var payload = json.decode(
                      ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                      .isAfter(DateTime.now())) {
                    return Home();
                  } else {
                    return LoginPage();
                  }
                }
              } else {
                return LoginPage();
              }
            }),
      ),
    );
  }
}
