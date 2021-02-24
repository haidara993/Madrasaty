import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:madrasatymobile/core/Models/LoginUser.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/Services.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:madrasatymobile/main.dart';

class AuthService extends Services {
  UserType userType = UserType.Student;
  StreamController<bool> isUserLoggedInStream = StreamController<bool>();
  StreamController<User> loggedInUserStream =
      StreamController.broadcast(sync: true);
  StreamController<UserType> userTypeStream = StreamController<UserType>();
  bool isUserLoggedIn = false;
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  Future<User> attemplogin(LoginUser user) async {
    Map data = {
      'UserName': user.username,
      'Password': user.password,
    };

    final Response response = await post(
      server_ip + 'api/auth/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      },
      body: jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      var user = User.fromJson(res);
      loggedInUserStream.add(user);
      isUserLoggedIn = true;
      isUserLoggedInStream.add(isUserLoggedIn);
      _sharedPreferencesHelper.setLoggedInUserId(user.id);

      var payload = JwtDecoder.decode(user.jwt);
      userType = UserTypeHelper.getEnum(payload["role"]);
      storage.write(key: "userType", value: payload["role"]);

      if (userType == UserType.Student) {
        this.userType = userType;
        userTypeStream.add(userType);
        sharedPreferencesHelper.setUserType(UserType.Student);
      } else {
        if (userType == UserType.Teacher) {
          this.userType = UserType.Teacher;
          userTypeStream.add(this.userType);
          sharedPreferencesHelper.setUserType(this.userType);
        } else {
          this.userType = UserType.Parent;
          userTypeStream.add(this.userType);
          sharedPreferencesHelper.setUserType(this.userType);
        }
      }

      // print(user.displayName);
      return user;
    }
    return null;
  }

  logoutMethod() async {
    await sharedPreferencesHelper.clearAllData();
    isUserLoggedIn = false;
    userTypeStream.add(UserType.Unkown);
    isUserLoggedInStream.add(isUserLoggedIn);
    print("User Loged out");
  }

  Future<int> attempSignUp(String username, String password) async {
    Map data = {
      'UserName': username,
      'Password': password,
    };
    var response = await post(
      server_ip + 'api/auth/register',
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode;
  }
}
