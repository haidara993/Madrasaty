import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Utility/custom_icons.dart';
import 'package:madrasatymobile/UI/pages/Assignment/AssignmentPage.dart';
import 'package:madrasatymobile/UI/pages/E-Card/E-CardPage.dart';
import 'package:madrasatymobile/UI/pages/Holidays/HolidayPage.dart';
import 'package:madrasatymobile/UI/pages/TimeTable/TimeTablePage.dart';
import 'package:madrasatymobile/UI/widgets/ColumnReusableCardButton.dart';
import 'package:madrasatymobile/UI/widgets/RowReusableCardButton.dart';

import 'Announcement/AnnouncementPage.dart';

class MainDashboard extends StatefulWidget {
  MainDashboard({Key key}) : super(key: key);
  static String pageName = "Dashboard";
  @override
  _MainDashboardState createState() => _MainDashboardState();

  @override
  String get screenName => 'ParentAndTeacher Dashboard';
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: ListView(
                children: [
                  // ColumnReusableCardButton(
                  //   onPressed: () {
                  //     // kopenPage(context, ChildrensPage());
                  //   },
                  //   icon: FontAwesomeIcons.child,
                  //   label: "Childrens",
                  //   tileColor: Colors.deepPurpleAccent,
                  //   directionIconHeroTag: "Childrens",
                  //   height: 100,
                  // ),
                  ColumnReusableCardButton(
                    onPressed: () {
                      kopenPage(context, ECardPage());
                    },
                    icon: Icons.perm_contact_calendar,
                    label: "E-Card",
                    tileColor: Colors.deepOrangeAccent,
                    directionIconHeroTag: "E-Card",
                    height: 100,
                  ),
                  ColumnReusableCardButton(
                    onPressed: () {
                      kopenPage(context, TimeTablePage());
                    },
                    icon: Icons.av_timer,
                    label: "TimeTable",
                    tileColor: Colors.yellow,
                    directionIconHeroTag: "TimeTable",
                    height: 100,
                  ),
                  ColumnReusableCardButton(
                    directionIconHeroTag: "Announcement",
                    height: 100,
                    tileColor: Colors.orangeAccent,
                    label: "Announcement",
                    icon: Icons.announcement_sharp,
                    onPressed: () {
                      kopenPage(context, AnnouncementPage());
                    },
                  ),
                  ColumnReusableCardButton(
                    directionIconHeroTag: "Assignments",
                    height: 100,
                    tileColor: Colors.lightGreen,
                    label: "Assignments",
                    icon: Icons.assessment,
                    onPressed: () {
                      kopenPage(context, AssignmentsPage());
                    },
                  ),
                  ColumnReusableCardButton(
                    directionIconHeroTag: "Holidays",
                    height: 100,
                    tileColor: Colors.blueGrey,
                    label: "Holidays",
                    icon: Icons.wallet_travel_sharp,
                    onPressed: () {
                      kopenPage(context, HolidayPage());
                    },
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
