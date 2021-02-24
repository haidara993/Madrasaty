import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/widgets/AssignmentBottomSheet.dart';
import 'package:madrasatymobile/UI/widgets/AssignmentDetailBottomSheet.dart';
import 'package:madrasatymobile/UI/widgets/ColumnReusableCardButton.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/Assignment.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/AssignmentServices.dart';
import 'package:madrasatymobile/core/viewModel/AssignmentPageModel.dart';
import 'package:random_color/random_color.dart';

import '../../../locator.dart';

class AssignmentsPage extends StatefulWidget {
  AssignmentsPage({Key key, this.standard = ''}) : super(key: key) {
    // setCurrentScreen();
  }

  final String standard;

  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();

  @override
  String get screenName => string.assignment + 'Page';
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  bool isTeacher = false;
  RandomColor _randomColor = RandomColor();
  ScrollController controller;
  AssignmentPageModel model;
  String stdDiv_Global;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLast = false;
  bool isLoaded = false;
  UserType userType;
  User user;
  List<Assignment> assignments = [];
  AssignmentServices assignmentServices = locator<AssignmentServices>();

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  void getUserType() async {
    userType = await _sharedPreferencesHelper.getUserType();

    if (userType == UserType.Teacher) {
      isTeacher = true;
    }
  }

  Future<User> getUser() async {
    _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
      final jsonData = json.decode(userDataModel);
      user = User.fromJson(jsonData);
    });
    assignments = await assignmentServices.getAssignments();
    return user;
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    getUser();
    getUserType();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (model.state == ViewState.Idle) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // setState(() => _isLoading = true);
        model.getAssignments();
        // scaffoldKey.currentState.widget
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.standard == '') {
      User currentUser = user;
      if (userType == UserType.Teacher) {
        if (!isLoaded) {
          stdDiv_Global =
              currentUser.standard + currentUser.division.toUpperCase() ??
                  'N.A';
          isLoaded = true;
        }
        isTeacher = true;
      } else if (userType == UserType.Parent) {
        stdDiv_Global = 'N.A';
      } else if (userType == UserType.Student) {
        if (!isLoaded) {
          stdDiv_Global =
              currentUser.standard + currentUser.division.toUpperCase();
          isLoaded = true;
        }
      }
    } else {
      stdDiv_Global = widget.standard;
      isLoaded = true;
    }

    // print(stdDiv_Global);
    return BaseView<AssignmentPageModel>(
      onModelReady: (model) =>
          stdDiv_Global != 'N.A' ? model.getAssignments() : model,
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: TopBar(
              title: string.assignment,
              child: kBackBtn,
              onPressed: () {
                kbackBtn(context);
              }),
          floatingActionButton: Visibility(
            visible: isTeacher,
            child: FloatingActionButton(
              onPressed: () {
                // buildShowDialogBox(context);
                // showAboutDialog(context: context);
                showModalBottomSheet(
                  elevation: 10,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => AssignmentBottomSheet(),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.red,
            ),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 700,
              ),
              child: RefreshIndicator(
                displacement: 10,
                child: stdDiv_Global == 'N.A'
                    ? Container(
                        child: Center(
                          child: Text(
                              '''Sorry, You Don\'t have any Class associated with you....!
If you are a parent then go to childrens section to check assignments''',
                              textAlign: TextAlign.center,
                              style: ksubtitleStyle.copyWith(
                                fontSize: 25,
                              )),
                        ),
                      )
                    : model.state == ViewState.Busy
                        ? kBuzyPage(color: Theme.of(context).primaryColor)
                        : model.assignments.length == 0
                            ? Container(
                                child: Center(
                                  child: Text(
                                    'No Assignments available....!',
                                    textAlign: TextAlign.center,
                                    style:
                                        ksubtitleStyle.copyWith(fontSize: 25),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                addAutomaticKeepAlives: true,
                                cacheExtent: 10,
                                controller: controller,
                                itemCount: model.assignments.length + 1,
                                itemBuilder: (context, i) {
                                  if (i < model.assignments.length) {
                                    Assignment assignment =
                                        model.assignments[i];
                                    print(assignment.id);
                                    return ColumnReusableCardButton(
                                      tileColor: _randomColor.randomColor(
                                          colorBrightness:
                                              ColorBrightness.veryDark,
                                          colorHue: ColorHue.purple,
                                          colorSaturation:
                                              ColorSaturation.highSaturation),
                                      label: assignment.title,
                                      icon: FontAwesomeIcons.bookOpen,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          elevation: 10,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              AssignmentDetailBottomSheet(
                                            assignment: assignment,
                                          ),
                                        );
                                      },
                                      height: 70,
                                    );
                                  } else {
                                    return Center(
                                      child: new Opacity(
                                        opacity: model.state == ViewState.Busy
                                            ? 1.0
                                            : 0.0,
                                        child: new SizedBox(
                                          width: 32.0,
                                          height: 32.0,
                                          child:
                                              new CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                onRefresh: () async {
                  await model.onRefresh();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
