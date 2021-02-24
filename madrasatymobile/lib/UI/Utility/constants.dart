import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ImageCompress.dart' as CompressImage;
import 'SlideRoute.dart';

var kTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  hintStyle: TextStyle(height: 1.5, fontWeight: FontWeight.w300),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

TextStyle ktitleStyle = TextStyle(fontWeight: FontWeight.w800);
TextStyle ksubtitleStyle = TextStyle(fontWeight: FontWeight.w600);

Color kmainColorTeacher = Color.fromRGBO(254, 198, 27, 1.0);
Color kmainColorStudents = Color.fromRGBO(244, 163, 52, 1.0);
Color kmainColorParents = Color.fromRGBO(249, 202, 36, 1.0);

ShapeBorder kRoundedButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
  ),
);

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
);

SnackBar ksnackBar(BuildContext context, String message) {
  return SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Theme.of(context).primaryColor,
  );
}

String createCryptoRandomString([int length = 32]) {
  final Random _random = Random.secure();
  var values = List<int>.generate(length, (i) => _random.nextInt(256));

  return base64Url.encode(values);
}

kopenPage(BuildContext context, Widget page) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

kbackBtn(BuildContext context) {
  Navigator.pop(context);
}

ShapeBorder kCardCircularShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

kopenPageBottom(BuildContext context, Widget page) {
  Navigator.of(context).push(
    CupertinoPageRoute<bool>(
      fullscreenDialog: true,
      builder: (BuildContext context) => page,
    ),
  );
}

kopenPageSlide(BuildContext context, Widget page, {Duration duration}) {
  return Navigator.push(
    context,
    RouteTransition(
        // fade: false,
        widget: page,
        duration: duration),
  );
}

Future openFileExplorer(
    FileType _pickingType, bool mounted, BuildContext context,
    {String extension}) async {
  File file;
  if (_pickingType == FileType.image) {
    if (extension == null) {
      file = await CompressImage.takeCompressedPicture(context);
      // if (file != null) _path = file.path;
      if (!mounted) return '';

      return file;
    } else {
      file = await FilePicker.getFile(type: _pickingType);
      if (!mounted) return '';
      return file;
    }
  } else if (_pickingType != FileType.custom) {
    try {
      file = await FilePicker.getFile(type: _pickingType);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return '';

    return file;
  } else if (_pickingType == FileType.custom) {
    try {
      if (extension == null) extension = 'PDF';
      file = await FilePicker.getFile(
          type: _pickingType, allowedExtensions: [extension]);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return '';
    return file;
  }
}

kBuzyPage({Color color = Colors.white}) {
  return Align(
    alignment: Alignment.center,
    child: SpinKitThreeBounce(
      color: color ?? Colors.white,
      size: 20.0,
    ),
  );
}

displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );
