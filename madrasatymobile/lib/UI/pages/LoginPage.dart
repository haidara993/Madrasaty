import 'dart:convert';

import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:madrasaty1/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/pages/ForgotPasswordPage.dart';
import 'package:madrasatymobile/UI/pages/Home.dart';
import 'package:madrasatymobile/UI/pages/Profile.dart';
import 'package:madrasatymobile/UI/widgets/LoginRoundedButton.dart';
import 'package:madrasatymobile/UI/widgets/ReusableRoundedButton.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/LoginUser.dart';
import 'package:madrasatymobile/core/enums/ButtonType.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/AuthService.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:madrasatymobile/main.dart';
// import 'package:madrasaty1/core/enums/ViewState.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui' as ui;

class LoginPage extends StatefulWidget {
  static const id = 'LoginPage';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserType loginTypeSelected = UserType.Unkown;
  bool isRegistered = false;
  String notYetRegisteringText = 'Not Registered?';
  ButtonType buttonType = ButtonType.LOGIN;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: TopBar(
        title: "LogIn",
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButton: LoginRoundedButton(
        label: buttonType == ButtonType.LOGIN ? 'Login' : 'Register',
        onPressed: () async {
          LoginUser user = new LoginUser();
          user.username = emailController.text;
          user.password = passwordController.text;

          var loggedUser = await authService.attemplogin(user);
          if (loggedUser != null) {
            storage.write(key: "jwt", value: loggedUser.jwt);

            var storedUser = loggedUser;
            // print(storedUser);
            _sharedPreferencesHelper.setUserDataModel(storedUser);

            kopenPage(context, Home());
          } else {
            displayDialog(context, "An Error Occurred",
                "No account was found matching that username and password");
          }
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: <Widget>[
                    // TextField(
                    //   onChanged: (id) {},
                    //   controller: schoolNameController,
                    //   keyboardType: TextInputType.text,
                    //   style:
                    //       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(16),
                    //     ),
                    //     hintStyle:
                    //         TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                    //     contentPadding: EdgeInsets.symmetric(
                    //         vertical: 10.0, horizontal: 20.0),
                    //   ).copyWith(
                    //     hintText: 'One which we gave',
                    //     labelText: 'School Name Code',
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (email) {},
                      keyboardType: TextInputType.emailAddress,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintStyle:
                            TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ).copyWith(
                        hintText: 'you@example.com',
                        labelText: 'Email',
                      ),
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (passwprd) {},
                      keyboardType: TextInputType.emailAddress,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintStyle:
                            TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ).copyWith(
                        hintText: 'min length is 7',
                        labelText: 'Passord',
                      ),
                      controller: passwordController,
                    ),
                    isRegistered
                        ? SizedBox(
                            height: 15,
                          )
                        : Container(),
                    isRegistered
                        ? TextField(
                            obscureText: true,
                            onChanged: (password) {},
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              hintStyle: TextStyle(
                                  height: 10.0, fontWeight: FontWeight.w300),
                            ).copyWith(
                              hintText: 'min length is 7',
                              labelText: 'Confirm Password',
                            ),
                            controller: confirmPasswordController,
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    // Hero(
                    //   tag: 'otpForget',
                    //   child: Container(
                    //     height: 50,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         ReusableRoundedButton(
                    //           child: Text(
                    //             notYetRegisteringText,
                    //             style: TextStyle(
                    //               // color: kmainColorTeacher,
                    //               fontSize: 15,
                    //             ),
                    //           ),
                    //           onPressed: () {
                    //             // _scaffoldKey.currentState.showSnackBar(
                    //             //     ksnackBar(context, 'message'));
                    //             setState(() {
                    //               if (buttonType == ButtonType.LOGIN) {
                    //                 buttonType = ButtonType.REGISTER;
                    //               } else {
                    //                 buttonType = ButtonType.LOGIN;
                    //               }
                    //               isRegistered = !isRegistered;
                    //               notYetRegisteringText = isRegistered
                    //                   ? 'Registered?'
                    //                   : 'Not Registered?';
                    //             });
                    //           },
                    //           height: 40,
                    //         ),
                    //         ReusableRoundedButton(
                    //           child: Text(
                    //             'Need Help?',
                    //             style: TextStyle(
                    //               // color: kmainColorTeacher,
                    //               fontSize: 15,
                    //             ),
                    //           ),
                    //           onPressed: () {
                    //             //Forget Password Logic
                    //             kopenPage(context, ForgotPasswordPage());
                    //           },
                    //           height: 40,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // // SizedBox(
                    //   height: 100,
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // model.state == ViewState.Busy
          //     ? Container(
          //         // color: Colors.red,
          //         child: BackdropFilter(
          //           filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          //           child: kBuzyPage(color: Theme.of(context).primaryColor),
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
