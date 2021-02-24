import 'package:flutter/material.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';

import '../../locator.dart';
import 'Home.dart';

class GuardianProfilePage extends StatefulWidget {
  static const id = 'GuardianPage';
  final String title;
  GuardianProfilePage({
    this.title = 'Profile',
    Key key,
  }) : super(key: key);

  @override
  _GuardianProfilePageState createState() => _GuardianProfilePageState();
}

class _GuardianProfilePageState extends State<GuardianProfilePage> {
  DateTime dateOfBirth;
  DateTime anniversaryDate;
  String path = 'default';
  UserType userType = UserType.Unkown;
  bool isEditable = false;
  bool floatingButtonVisibility = false;

  Future<DateTime> _selectDate(BuildContext context, DateTime date) async {
    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
    return picked;
  }

  @override
  void initState() {
    super.initState();
  }

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  String _name = '';
  String _childrenNameName = '';
  String _bloodGroup = '';
  String _dob = '';
  String _mobileNo = '';
  int a = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // floatingButtonPressed(
  //     var model, UserType userType, User User) async {
  //   bool res = false;

  //   if (_bloodGroup.isEmpty ||
  //       _name.isEmpty ||
  //       _dob.isEmpty ||
  //       _childrenNameName.isEmpty ||
  //       _mobileNo.isEmpty) {
  //     _scaffoldKey.currentState.showSnackBar(ksnackBar(context, 'You Need to fill all the details and a profile Photo'),);
  //   } else {
  //     if (model.state == ViewState.Idle) {
  //       res = await model.setUserProfileData(
  //         user: User(
  //             bloodGroup: _bloodGroup.trim(),
  //             displayName: _name.trim(),
  //             dob: _dob.trim(),
  //             guardianName: _childrenNameName.trim(),
  //             mobileNo: _mobileNo.trim(),
  //             email: firebaseUser.email,
  //             firebaseUuid: firebaseUser.uid,
  //             id: await _sharedPreferencesHelper.getLoggedInUserId(),
  //             isTeacher: false,
  //             isVerified: firebaseUser.isEmailVerified,
  //             connection: await getConnection(userType),
  //             photoUrl: path),
  //         userType: userType,
  //       );
  //     }
  //   }

  //   if (res == true) {
  //     Navigator.pushNamedAndRemoveUntil(context, Home.id, (r) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
