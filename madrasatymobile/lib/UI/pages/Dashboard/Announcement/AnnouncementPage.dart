import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/pages/Dashboard/Announcement/CreateAnnouncement.dart';
import 'package:madrasatymobile/UI/widgets/AnnouncementCard.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/AnnouncementServices.dart';
import 'package:madrasatymobile/core/viewModel/Announcement/AnnouncementPageModel.dart';
import 'package:madrasatymobile/locator.dart';

class AnnouncementPage extends StatefulWidget {
  AnnouncementPage({
    Key key,
    this.announcementFor = '',
  }) : super(key: key) {
    // setCurrentScreen();
  }

  final String announcementFor;

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();

  @override
  String get screenName => string.announcement + 'Page';
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with AutomaticKeepAliveClientMixin {
  bool isTeacher = false;

  ScrollController controller;
  AnnouncementPageModel model = AnnouncementPageModel();
  String stdDiv_Global = 'Global';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLast = false;
  bool isLoaded = false;
  String buttonLabel = 'Global';
  User user;
  TextEditingController _standardController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();
  UserType userType;
  List<Announcement> announcemets = [];
  AnnouncementServices announcementServices = locator<AnnouncementServices>();

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
    announcemets = await announcementServices.getAnnouncements();
    return user;
  }

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    stdDiv_Global =
        widget.announcementFor == '' ? 'Global' : widget.announcementFor;
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
        model.getAnnouncements();
        // scaffoldKey.currentState.widget
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = user;
    if (userType == UserType.Teacher) {
      isTeacher = true;
    } else if (userType == UserType.Parent) {
    } else if (userType == UserType.Student) {
      if (!isLoaded) {
        stdDiv_Global =
            currentUser.standard + currentUser.division.toUpperCase();
        isLoaded = true;
      }

      print(stdDiv_Global);
    }
    return BaseView<AnnouncementPageModel>(
        onModelReady: (model) => model.getAnnouncements(),
        builder: (context, model, child) {
          this.model = model;
          return Scaffold(
            key: scaffoldKey,
            appBar: TopBar(
                buttonHeroTag: string.announcement,
                title: stdDiv_Global + " Posts",
                child: kBackBtn,
                onPressed: () {
                  kbackBtn(context);
                }),
            // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: Stack(
              children: <Widget>[
                Visibility(
                  visible: isTeacher,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      elevation: 12,
                      onPressed: () {
                        kopenPageSlide(context, CreateAnnouncement(),
                            duration: Duration(milliseconds: 200));
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 31),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: userType == UserType.Student
                        ? FloatingActionButton.extended(
                            label: Text(buttonLabel),
                            heroTag: 'abc',
                            elevation: 12,
                            onPressed: () async {
                              if (stdDiv_Global == 'Global') {
                                setState(() {
                                  buttonLabel = stdDiv_Global;
                                  stdDiv_Global = currentUser.standard +
                                      currentUser.division.toUpperCase();
                                });
                              } else {
                                setState(() {
                                  buttonLabel = stdDiv_Global;
                                  stdDiv_Global = 'Global';
                                });
                              }

                              await model.onRefresh(user.divisionId);
                            },
                            icon: Icon(FontAwesomeIcons.globe),
                            backgroundColor: Colors.red,
                          )
                        : userType == UserType.Teacher
                            ? FloatingActionButton.extended(
                                label: Text('Filter'),
                                heroTag: 'abc',
                                elevation: 12,
                                onPressed: () {
                                  //Filter Posts Code Here
                                  filterDialogBox(context, model);
                                },
                                icon: Icon(Icons.filter_list),
                                backgroundColor: Colors.red,
                              )
                            : Container(),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: RefreshIndicator(
                  child: announcemets.length == 0
                      ? model.state == ViewState.Busy
                          ? kBuzyPage(color: Theme.of(context).accentColor)
                          : Container(
                              child: Center(
                                child: Text(
                                  'No Posts available....!',
                                  style: ksubtitleStyle.copyWith(fontSize: 25),
                                ),
                              ),
                              // color: Colors.red,
                            )
                      : ListView.builder(
                          addAutomaticKeepAlives: true,
                          cacheExtent: 10,
                          controller: controller,
                          itemCount: announcemets.length + 1,
                          itemBuilder: (context, index) {
                            if (index < announcemets.length) {
                              return AnnouncementCard(
                                  announcement: announcemets[index]);
                            } else {
                              return Center(
                                child: new Opacity(
                                  opacity:
                                      model.state == ViewState.Busy ? 1.0 : 0.0,
                                  child: new SizedBox(
                                      width: 32.0,
                                      height: 32.0,
                                      child: kBuzyPage(
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              );
                            }
                          },
                        ),
                  onRefresh: () async {
                    await model.onRefresh(user.divisionId);
                  },
                ),
              ),
            ),
          );
        });
  }

  Future filterDialogBox(BuildContext context, AnnouncementPageModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            string.show_announcement_of,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                string.filter_announcement,
                // style: TextStyle(fontFamily: 'Subtitle'),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _standardController,
                  onChanged: (standard) {},
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  // decoration: InputDecoration(
                  //     hintText: "Master Pass",
                  //     hintStyle: TextStyle(fontFamily: "Subtitle"),
                  //     ),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: string.standard_hint,
                    labelText: string.standard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _divisionController,
                  onChanged: (division) {},
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: string.division_hint,
                    labelText: string.division,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(string.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  child: Text('Global'.toUpperCase()),
                  onPressed: () async {
                    setState(() {
                      stdDiv_Global = 'Global';
                    });
                    await model.onRefresh(user.divisionId);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  child: Text(string.filter),
                  onPressed: () async {
                    setState(() {
                      stdDiv_Global = _standardController.text.trim() +
                          _divisionController.text.trim().toUpperCase();
                    });
                    await model.onRefresh(user.divisionId);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
