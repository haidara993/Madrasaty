import 'dart:convert';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Widgets/TopBar.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/viewmodel/ProfilePageModel.dart';
import 'package:madrasatymobile/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../locator.dart';

class ECardPage extends StatefulWidget {
  const ECardPage({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _ECardPageState createState() => _ECardPageState();
}

class _ECardPageState extends State<ECardPage> {
  User user;
  UserType userType;

  _ECardPageState() {
    getState();
  }
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  void getState() async {
    userType = await _sharedPreferencesHelper.getUserType();
  }

  int loggedUserId;
  Future<User> getUser() async {
    _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
      final jsonData = json.decode(userDataModel);
      user = User.fromJson(jsonData);
      loggedUserId = user.id;
    });
    String jwt = await storage.read(key: "jwt");
    final http.Response response = await http.get(
      server_ip + 'api/auth/get' + loggedUserId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = await json.decode(response.body);

      User user = User.fromJson(jsonData);
      _sharedPreferencesHelper.setUserDataModel(user);
      return user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            alignment: Alignment.center,
            child: SpinKitThreeBounce(
              color: Theme.of(context).accentColor ?? Colors.white,
              size: 20.0,
            ),
          );
        }
        return Scaffold(
          appBar: TopBar(
            title: "E-Card",
            child: kBackBtn,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Hero(
                      tag: 'profileeee',
                      transitionOnUserGestures: true,
                      child: Container(
                        constraints:
                            BoxConstraints(maxHeight: 200, maxWidth: 200),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: user.photoUrl != 'default'
                                ? NetworkImage(
                                    user.photoUrl,
                                  )
                                : AssetImage(assetsString.student_welcome),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      ProfileFieldsECard(
                        width: MediaQuery.of(context).size.width,
                        labelText: 'Student/Teacher Name',
                        initialText: user.displayName,
                      ),
                      userType == UserType.Parent
                          ? Container()
                          : ProfileFieldsECard(
                              width: MediaQuery.of(context).size.width,
                              labelText: 'Student 0r Teacher Roll no',
                              initialText: user.enrollNo,
                            ),
                      userType == UserType.Parent
                          ? Container()
                          : Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: ProfileFieldsECard(
                                    labelText: "Standard",
                                    initialText: user.standard,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ProfileFieldsECard(
                                    labelText: "Division",
                                    initialText: user.division.toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                      ProfileFieldsECard(
                        width: MediaQuery.of(context).size.width,
                        labelText: userType == UserType.Parent
                            ? "Childrens Name.."
                            : "Guardian Name",
                        initialText: user.guardianName,
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ProfileFieldsECard(
                              labelText: "date of birth",
                              initialText: user.dob,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ProfileFieldsECard(
                              labelText: "Blood Group",
                              initialText: user.bloodGroup,
                            ),
                          ),
                        ],
                      ),
                      ProfileFieldsECard(
                        width: MediaQuery.of(context).size.width,
                        labelText: "Mobile No",
                        initialText: user.mobileNo,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileFieldsECard extends StatelessWidget {
  final String initialText;
  final String labelText;
  final double width;

  const ProfileFieldsECard(
      {this.initialText, @required this.labelText, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      // width: width == null ? MediaQuery.of(context).size.width / 2.5 : width,
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: initialText),
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintStyle: TextStyle(height: 2.0, fontWeight: FontWeight.w300),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
