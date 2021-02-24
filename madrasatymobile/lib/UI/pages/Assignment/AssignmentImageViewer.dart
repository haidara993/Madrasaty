import 'package:flutter/material.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/Widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/Assignment.dart';
import 'package:photo_view/photo_view.dart';

class AssignmentImageViewer extends StatefulWidget {
  AssignmentImageViewer({Key key, this.assignment}) : super(key: key);
  final Assignment assignment;

  _AssignmentImageViewerState createState() => _AssignmentImageViewerState();
}

class _AssignmentImageViewerState extends State<AssignmentImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: widget.assignment.title,
        child: kBackBtn,
        onPressed: () {
          kbackBtn(context);
        },
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.assignment.url),
        basePosition: Alignment.center,
        backgroundDecoration:
            BoxDecoration(color: Theme.of(context).canvasColor),
        // zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      ),
    );
  }
}
