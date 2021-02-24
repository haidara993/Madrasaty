import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Utility/custom_icons.dart';
import 'package:madrasatymobile/UI/pages/E-Card/E-CardPage.dart';
import 'package:madrasatymobile/UI/pages/TimeTable/TimeTablePage.dart';
import 'package:madrasatymobile/UI/widgets/ColumnReusableCardButton.dart';
import 'package:madrasatymobile/UI/widgets/RowReusableCardButton.dart';

class StudentDashboard extends StatefulWidget {
  StudentDashboard({Key key}) : super(key: key);

  static String pageName = "Dashboard";
  @override
  _StudentDashboardState createState() => _StudentDashboardState();

  @override
  String get screenName => 'Students Dashboard';
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RowReusableCardButton(
                            tileColor: Colors.deepOrangeAccent,
                            label: "E-Card",
                            onPressed: () {
                              kopenPage(context, ECardPage());
                            },
                            icon: Icons.perm_contact_calendar,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            tileColor: null,
                            icon: Icons.av_timer,
                            label: "Time Table",
                            onPressed: () {
                              kopenPage(context, TimeTablePage());
                            },
                          ),
                        ],
                      ),
                    ),
                    ColumnReusableCardButton(
                      height: 70,
                      tileColor: Colors.orangeAccent,
                      label: "Announcement",
                      icon: Icons.announcement_sharp,
                      onPressed: () {
                        // kopenPage(context, AnnouncementPage());
                      },
                    ),
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RowReusableCardButton(
                            tileColor: Colors.blueGrey,
                            icon: Icons.card_travel_sharp,
                            label: "Holidays",
                            onPressed: () {
                              // kopenPage(context, HolidayPage());
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            tileColor: Colors.indigoAccent,
                            icon: Icons.assessment,
                            label: "Results",
                            onPressed: () {
                              // kopenPage(context, ResultPage());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RowReusableCardButton(
                            tileColor: Colors.lightGreen,
                            label: "Assignments",
                            onPressed: () {
                              // kopenPage(context, AssignmentsPage());
                            },
                            icon: Icons.assignment,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RowReusableCardButton(
                            tileColor: Colors.lime,
                            icon: Icons.attach_money,
                            label: "Fees",
                            onPressed: () {
                              // kopenPage(context, FeesPage());
                            },
                          ),
                        ],
                      ),
                    ),
                    ColumnReusableCardButton(
                        height: 70,
                        tileColor: Colors.grey,
                        label: "Transportation",
                        onPressed: () {
                          // kopenPage(context, TransportationPage());
                        },
                        icon: FontAwesomeIcons.bus),
                    SizedBox(
                      height: 105,
                      child: ListView(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RowReusableCardButtonBanner(
                                paddingTop: 0,
                                tileColor: Colors.pink,
                                icon: Icons.assistant_photo,
                                label: "Exams",
                                onPressed: () {
                                  // kopenPage(context, TopicSelectPage());
                                },
                              ),
                              RowReusableCardButtonBanner(
                                paddingTop: 0,
                                tileColor: Colors.tealAccent,
                                icon: FontAwesomeIcons.book,
                                label: "E-Books",
                                onPressed: () {
                                  // kopenPage(context, EBookSelect());
                                },
                              ),
                              RowReusableCardButtonBanner(
                                paddingTop: 0,
                                tileColor: Colors.deepPurpleAccent,
                                icon: FontAwesomeIcons.cameraRetro,
                                label: "Video",
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 110,
                      child: ListView(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RowReusableCardButtonBanner(
                                tileColor: Colors.pinkAccent,
                                icon: FontAwesomeIcons.female,
                                label: "Parenting Guide",
                                onPressed: () {
                                  // kopenPage(context, ParentingGuidePage());
                                },
                              ),
                              RowReusableCardButtonBanner(
                                tileColor: Colors.red,
                                icon: FontAwesomeIcons.medkit,
                                label: "health_tips",
                                onPressed: () {},
                              ),
                              RowReusableCardButtonBanner(
                                tileColor: Colors.blue,
                                icon: FontAwesomeIcons.userMd,
                                label: "vaccinations",
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ColumnReusableCardButton(
                      tileColor: Colors.greenAccent,
                      height: 70,
                      label: "offers",
                      onPressed: () {},
                      icon: Icons.receipt,
                      directionIcon: Icons.chevron_right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
