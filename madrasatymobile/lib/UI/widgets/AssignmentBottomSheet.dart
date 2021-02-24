import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/core/Models/Assignment.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/viewModel/AssignmentPageModel.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../locator.dart';

class AssignmentBottomSheet extends StatefulWidget {
  AssignmentBottomSheet();
  @override
  _AssignmentBottomSheetState createState() => _AssignmentBottomSheetState();
}

class _AssignmentBottomSheetState extends State<AssignmentBottomSheet> {
  TextEditingController _fileNamecontroller = TextEditingController();

  String _fileName;
  String _path = null;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _standardController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();
  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  User user;
  File file;

  Future<String> uploadImage(file) async {
    String jwt = await storage.read(key: "jwt");
    String fileName = file.path;
    var request = http.MultipartRequest(
        'POST', Uri.parse(server_ip + 'api/upload/assignment/'));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    var res = await request.send();
    print(res.reasonPhrase);
    print(res.statusCode);
    var result = await res.stream.bytesToString();

    return result;
  }

  _uploadButtonPressed(var model) async {
    if (
        // _path != null &&
        _titleController.text.trim() != '' &&
            _descriptionController.text.trim() != '' &&
            _divisionController.text.trim() != '' &&
            _standardController.text.trim() != '' &&
            _standardController.text.trim() != '') {
      _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
        final jsonData = json.decode(userDataModel);
        user = User.fromJson(jsonData);
      });
      if (file != null) {
        _path = await uploadImage(file);
        print(_path);
        // kbackBtn(context);
      }
      Assignment assignment = Assignment(
        title: _titleController.text.trim(),
        userId: user.id,
        details: _descriptionController.text.trim(),
        divisionId: int.parse(_divisionController.text),
        standardId: int.parse(_standardController.text),
        url: _path,
        subject: _subjectController.text.trim(),
      );

      int res = await model.addAssignment(assignment);
      if (res == 200) {
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        ksnackBar(context, 'All the fields are mandatory...'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AssignmentPageModel>(builder: (context, model, child) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 31),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () async {
                        file = await openFileExplorer(
                            FileType.custom, mounted, context,
                            extension: 'PDF');
                        setState(() {
                          _fileName = file.path != null
                              ? file.path.split('/').last
                              : '...';
                          print(_fileName);
                          if (_fileName.isNotEmpty) {
                            _fileNamecontroller.text = _fileName;
                          }
                        });
                      },
                      child: Icon(FontAwesomeIcons.filePdf),
                    ),
                    Text(
                      ' OR ',
                      style: ktitleStyle,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        file = await openFileExplorer(
                            FileType.image, mounted, context,
                            extension: 'NOCOMPRESSION');
                        setState(() {
                          _fileName = file.path != null
                              ? file.path.split('/').last
                              : '...';
                          print(_fileName);
                          if (_fileName.isNotEmpty) {
                            _fileNamecontroller.text = _fileName;
                          }
                        });
                      },
                      child: Icon(FontAwesomeIcons.fileImage),
                    ),
                  ],
                ),
              ),
              FloatingActionButton.extended(
                isExtended: model.state == ViewState.Idle ? true : false,
                label: model.state == ViewState.Idle
                    ? Text('Upload')
                    : Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SpinKitDoubleBounce(
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                onPressed: () async {
                  if (model.state == ViewState.Idle)
                    await _uploadButtonPressed(model);
                },
                icon: model.state == ViewState.Idle
                    ? Icon(FontAwesomeIcons.arrowCircleUp)
                    : Container(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: Text(
                      'Upload Assignment...',
                      style: ktitleStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  TextField(
                      controller: _titleController,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: string.title,
                        labelText: string.title,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 150,
                    // color: Colors.blueAccent.withOpacity(0.5),
                    child: TextField(
                      controller: _descriptionController,
                      autocorrect: true,
                      maxLength: null,
                      maxLines: 30,
                      // expands: true,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: string.description_optional,
                        labelText: string.topic_description,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _fileNamecontroller,
                    enabled: false,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: string.file_name,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _subjectController,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Subject',
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _standardController,
                          keyboardType: TextInputType.number,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: string.standard,
                            labelText: string.standard,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _divisionController,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: string.division,
                            hintText: string.division,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
