import 'dart:convert';
import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Utility/custom_icons.dart';
import 'package:madrasatymobile/UI/pages/Dashboard/MainDashboard.dart';
import 'package:madrasatymobile/UI/pages/Dashboard/StudentDashboard.dart';
import 'package:madrasatymobile/UI/pages/LoginPage.dart';
import 'package:madrasatymobile/UI/pages/Profile.dart';
import 'package:madrasatymobile/UI/pages/Settings/SettingsPage.dart';
import 'package:madrasatymobile/UI/widgets/BottomBar.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/viewModel/ProfilePageModel.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import '../../main.dart';
import 'GuardianProfilePage.dart';

class Home extends StatefulWidget {
  static const id = 'Home';
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';

  var currentIndex = 0;
  Color background = Colors.white;
  // AuthenticationServices _auth = locator<AuthenticationServices>();
  bool isTeacher = false;
  // MainPageModel mainPageModel;
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  // _auth.userType == UserType.STUDENT ? false : true;
  String pageName = "Home";
  User user;
  UserType userType;

  List<Widget> pages = [
    MainDashboard(),
    // NotificationPage(),
    SettingPage()
  ];

  List<Widget> studentPages = [
    StudentDashboard(),
    SettingPage(),
  ];

  // _registerOnFirebase() {
  //   _firebaseMessaging.subscribeToTopic('all');
  //   _firebaseMessaging.getToken().then((token) => print(token));
  // }

  // void getMessage() {
  //   _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //     print('received message');
  //     setState(() => _message = message["notification"]["body"]);
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('on resume $message');
  //     setState(() => _message = message["notification"]["body"]);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('on launch $message');
  //     setState(() => _message = message["notification"]["body"]);
  //   });
  // }

  @override
  void initState() {
    // _registerOnFirebase();
    // getMessage();
    super.initState();
  }

  _HomeState() {
    getState();
  }

  void getState() async {
    userType = await _sharedPreferencesHelper.getUserType();

    if (userType == UserType.Teacher) {
      isTeacher = true;
    }
  }

  int loggedUserId;
  Future<User> getUser() async {
    _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
      final jsonData = json.decode(userDataModel);
      // print("sadasdasdasdadasda" + userDataModel);
      user = User.fromJson(jsonData);
      loggedUserId = user.id;
    });
    String jwt = await storage.read(key: "jwt");
    final Response response = await get(
      server_ip + 'api/auth/get/' + loggedUserId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = await json.decode(response.body);

      User user = User.fromJson(jsonData);
      _sharedPreferencesHelper.setUserDataModel(user);

      return user;
    }
    return user;
  }

  ImageProvider<dynamic> setImage(User user) {
    // print(user.photoUrl);

    return user.photoUrl != 'default'
        ? NetworkImage(
            user.photoUrl,
          )
        : AssetImage(assetsString.student_welcome);
  }

  @override
  Widget build(BuildContext context) {
    // userType = Provider.of<UserType>(context, listen: false);
    // user = Provider.of<User>(context, listen: false);
    return FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: kBuzyPage(color: Theme.of(context).accentColor),
            color: Colors.white,
          );
        }
        return Scaffold(
          appBar: TopBar(
              title: pageName,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Image(
                  image: setImage(user),
                  height: 30,
                  width: 30,
                ),
              ),
              onPressed: () {
                if (userType == UserType.Parent) {
                  kopenPage(context, GuardianProfilePage());
                } else {
                  kopenPage(context, Profile());
                }
              }),
          floatingActionButton: Visibility(
            visible: isTeacher,
            child: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
              backgroundColor: Colors.red,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: buildBubbleBottomBar(userType),
          body: userType == UserType.Student
              ? IndexedStack(
                  index: currentIndex,
                  children: studentPages,
                )
              : IndexedStack(
                  index: currentIndex,
                  children: pages,
                ),
        );
      },
    );
    // return BaseView<ProfilePageModel>(
    //   onModelReady: (model) => model.getUserProfileData(),
    //   builder: (context, model, child) {
    //     user = model.userData;
    //     },
    // );
  }

  List<BubbleBottomBarItem> studentItems = [
    BubbleBottomBarItem(
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.dashboard,
      ),
      activeIcon: Icon(
        Icons.dashboard,
        color: Colors.red,
      ),
      title: Text("Dashboard"),
    ),
    BubbleBottomBarItem(
      backgroundColor: Colors.orange,
      icon: Icon(
        Icons.settings,
      ),
      activeIcon: Icon(
        Icons.settings,
        color: Colors.orange,
      ),
      title: Text(
        "Settings",
      ),
    )
  ];

  List<BubbleBottomBarItem> bottomBarItems = [
    BubbleBottomBarItem(
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.dashboard,
      ),
      activeIcon: Icon(
        Icons.dashboard,
        color: Colors.red,
      ),
      title: Text("Dashboard"),
    ),
    BubbleBottomBarItem(
      backgroundColor: Colors.orange,
      icon: Icon(
        Icons.settings,
      ),
      activeIcon: Icon(
        Icons.settings,
        color: Colors.orange,
      ),
      title: Text(
        "Settings",
      ),
    )
  ];

  BubbleBottomBar buildBubbleBottomBar(UserType userType) {
    return BubbleBottomBar(
      backgroundColor: Theme.of(context).canvasColor,
      opacity: .2,
      currentIndex: currentIndex,
      onTap: (v) {
        if (userType == UserType.Student) {
          setState(() {
            if (v == 0) {
              pageName = MainDashboard.pageName;
            } else {
              pageName = "Settings";
            }
            currentIndex = v;
          });
        } else {
          setState(() {
            if (v == 0) {
              pageName = MainDashboard.pageName;
            } else if (v == 1) {
              pageName = "Chat";
            } else if (v == 2) {
              pageName = "Settings";
            }
            currentIndex = v;
          });
        }
      },
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      elevation: 10,
      fabLocation: isTeacher ? BubbleBottomBarFabLocation.end : null,
      hasNotch: isTeacher,
      hasInk: true,
      inkColor: Colors.black12,
      items: userType == UserType.Student ? studentItems : bottomBarItems,
    );
  }
}
