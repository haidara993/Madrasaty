import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/locator.dart';
import 'StudentsTimeTable.dart';
import 'TeachersTimeTable.dart';

class TimeTablePage extends StatefulWidget {
  TimeTablePage({Key key}) : super(key: key);

  _TimeTablePageState createState() => _TimeTablePageState();
}

const List<String> tabNames = const <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thrusday',
  'Friday',
  'Saturday'
];

class _TimeTablePageState extends State<TimeTablePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Color color = Colors.red;
  bool teacher = true;
  bool edit = false;
  UserType userType;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: tabNames.length);
  }

  Future<UserType> getUserType() async {
    SharedPreferencesHelper sharedPreferencesHelper =
        locator<SharedPreferencesHelper>();
    userType = await sharedPreferencesHelper.getUserType();
    return userType;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserType>(
      future: getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return kBuzyPage(color: Theme.of(context).accentColor);
        }
        return Scaffold(
          appBar: TopBar(
            title: "TimeTable",
            child: kBackBtn,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          floatingActionButton: userType == UserType.Teacher
              ? FloatingActionButton(
                  onPressed: () {
                    edit = !edit;
                    setState(() {});
                  },
                  child: Icon(
                    !edit ? FontAwesomeIcons.solidEdit : FontAwesomeIcons.save,
                    size: 20,
                  ),
                  backgroundColor: Colors.red,
                )
              : Container(),
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              tabNames.length,
              (index) => teacher
                  ? TeachersTimeTable(
                      color: color,
                      edit: edit,
                    )
                  : StudentsTimeTable(
                      color: color,
                      edit: edit,
                    ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userType == UserType.Teacher
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              teacher = true;
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              color: teacher ? color : Colors.white,
                              child: Center(
                                child: Text(
                                  'Teachers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        !teacher ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              teacher = false;
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              color: !teacher ? color : Colors.white,
                              child: Center(
                                child: Text(
                                  'Students',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        teacher ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              AnimatedCrossFade(
                firstChild: Material(
                  color: Theme.of(context).primaryColor,
                  child: TabBar(
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    isScrollable: true,
                    tabs: List.generate(tabNames.length, (index) {
                      return Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            tabNames[index].toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                secondChild: Container(),
                crossFadeState: CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        );
      },
    );
  }
}
