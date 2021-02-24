import 'dart:async';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/services/ProfileService.dart';
import 'package:madrasatymobile/core/viewmodel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class ProfilePageModel extends BaseModel {
  final _profileServices = locator<ProfileService>();

  User userProfile;
  User get userData => userProfile;
  // List<User> get childrens => _profileServices.childrens;

  ProfilePageModel() {
    getUserProfileData();
    // getChildrens();
  }

  // ProfilePageModel.getChildrens() {
  //   getChildrens();
  // }

  Future<User> getUserProfileData() async {
    setState(ViewState.Busy);
    setState2(ViewState.Busy);
    userProfile = await _profileServices.getLoggedInUserProfileData();
    notifyListeners();
    setState(ViewState.Idle);
    setState2(ViewState.Idle);
    return userProfile;
  }

  Future<int> setUserProfileData({User user, UserType userType}) async {
    setState(ViewState.Busy);
    int res;
    res = await _profileServices.setProfileData(user: user, userType: userType);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3), () {});
    setState(ViewState.Idle);
    return res;
  }

  // getChildrens() async {
  //   setState(ViewState.Busy);
  //   await _profileServices.getChildrens();
  //   setState(ViewState.Idle);
  // }

  // _getChildrensData(Map<String, int> childIds) async {
  //   List<User> childData = [];
  //   for (int id in childIds.values) {
  //     childData.add(await getUserProfileDataById(UserType.Student, id));
  //   }
  // childrens = childData;
  //   return childData;
  // }

  Future<User> getUserProfileDataById(UserType userType, int id) async {
    setState(ViewState.Busy);
    userProfile = await _profileServices.getProfileDataById(id, userType);
    setState(ViewState.Idle);
    return userProfile;
  }

  Future<User> getUserProfileDataByIdForAnnouncement(
      UserType userType, int id) async {
    userProfile = await _profileServices.getProfileDataById(id, userType);
    return userProfile;
  }

  @override
  void dispose() {
    if (true) {}
  }

  // Future<User> getUserProfileDataOfGuardian(UserType userType, String id) async {
  //   setState(ViewState.Busy);
  //   setState2(ViewState.Busy);
  //   // String id = await _sharedPreferences.getLoggedInUserId();
  //   // UserType userType = await _sharedPreferences.getUserType();
  //   userProfile = await _profileServices.getProfileData(id, userType);
  //   setState2(ViewState.Idle);
  //   setState(ViewState.Idle);
  //   return userProfile;
  // }
}
