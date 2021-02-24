import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/pages/About/About.dart';
import 'package:madrasatymobile/UI/pages/GuardianProfilePage.dart';
import 'package:madrasatymobile/UI/pages/LoginPage.dart';
import 'package:madrasatymobile/UI/pages/Profile.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/AuthService.dart';

import '../../../locator.dart';
import '../ForgotPasswordPage.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);
  static String pageName = "Settings";
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferencesHelper preferencesHelper =
      locator<SharedPreferencesHelper>();
  UserType userType;
  Future<UserType> getState() async {
    userType = await preferencesHelper.getUserType();
    return userType;
  }

  AuthService authService = locator<AuthService>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserType>(
      future: getState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return kBuzyPage(color: Theme.of(context).accentColor);
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  settingTiles(
                    context: context,
                    icon: FontAwesomeIcons.user,
                    onTap: () {
                      if (userType == UserType.Parent) {
                        kopenPage(context, GuardianProfilePage());
                      } else {
                        kopenPage(context, Profile());
                      }
                    },
                    subtitle: 'Kind of everything we know about you',
                    title: "Profile",
                  ),
                  settingTiles(
                      context: context,
                      icon: FontAwesomeIcons.signOutAlt,
                      onTap: () async {
                        await authService.logoutMethod();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, WelcomeScreen.id, (r) => false);
                      },
                      subtitle: 'You can login in multiple devices too',
                      title: "Log Out"),
                  settingTiles(
                      context: context,
                      icon: Icons.restore,
                      onTap: () {
                        kopenPage(context, ForgotPasswordPage());
                      },
                      subtitle: 'Send recovery mail',
                      title: 'Forgot Password'),
                  settingTiles(
                      context: context,
                      icon: Icons.contact_mail,
                      onTap: () async {
                        print((await preferencesHelper.getParentsIds())
                            .toString());
                        kopenPage(context, AboutUs());
                      },
                      subtitle: 'Contact us',
                      title: 'About!'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell settingTiles(
      {BuildContext context,
      Function onTap,
      String title,
      String subtitle,
      IconData icon}) {
    return InkWell(
      splashColor: Colors.red[100],
      onTap: onTap,
      child: ListTile(
        trailing: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold
              // fontFamily: 'Ninto',
              ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
