import 'package:flutter/material.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Widgets/TopBar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
          child: kBackBtn,
          onPressed: () {
            Navigator.pop(context);
          },
          title: "About!",
        ),
        body: Container());
  }
}
