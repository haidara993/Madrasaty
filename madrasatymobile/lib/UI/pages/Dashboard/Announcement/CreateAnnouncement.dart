import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/enums/announcementType.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/viewModel/Announcement/AnnouncementPageModel.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:image/image.dart' as Im;
import 'package:madrasatymobile/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CreateAnnouncement extends StatefulWidget {
  CreateAnnouncement({Key key}) : super(key: key);

  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  String path = 'default';

  TextEditingController _standardController;
  TextEditingController _divisionController;
  TextEditingController _captionController;

  AnnouncementType announcementType = AnnouncementType.EVENT;

  FocusNode _focusNode = new FocusNode();
  var _scaffoldKey;
  bool isPosting = false;
  Color postTypeFontColor = Colors.black;
  bool isReadyToPost = false;
  String postType = 'GLOBAL';

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  User user;
  Future<User> getUser() async {
    _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
      final jsonData = json.decode(userDataModel);
      user = User.fromJson(jsonData);
    });
    return user;
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _standardController = TextEditingController();
    _captionController = TextEditingController();
    _divisionController = TextEditingController();
    getUser();
  }

  floatingButtonPressed(
      AnnouncementPageModel model, BuildContext context) async {
    if (file != null) {
      // await compressImage();
      path = await uploadImage(file);
      print(path);
      kbackBtn(context);
    }
    var announcement = Announcement(
        userId: user.id,
        userPhotoUrl: user.photoUrl,
        displayName: user.displayName,
        caption: _captionController.text,
        standardId:
            postType == 'SPECIFIC' ? int.parse(_standardController.text) : 0,
        divisionId:
            postType == 'SPECIFIC' ? int.parse(_divisionController.text) : 0,
        photoUrl: path,
        anouncementType: AnnouncementTypeHelper.getValue(announcementType),
        timestamp: "");
    if (postType == 'SPECIFIC') {
      if (_standardController.text.trim() == '' ||
          _divisionController.text.trim() == '') {
        _scaffoldKey.currentState.showSnackBar(
            ksnackBar(context, 'Please Specify Class and Division'));
      } else {
        int res = await model.postAnnouncement(announcement);
        if (res == 200) {
          kbackBtn(context);
        }
      }
    } else {
      int res = await model.postAnnouncement(announcement);
      if (res == 200) {
        kbackBtn(context);
      }
    }
  }

  File file;
  handletakephoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    final tempDir = await getTemporaryDirectory();
    path = tempDir.path;
    setState(() {
      this.file = file;
    });
  }

  handlechoosephoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final tempDir = await getTemporaryDirectory();
    path = tempDir.path;
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create post .."),
          children: [
            SimpleDialogOption(
              child: Text("Photo with a camera"),
              onPressed: handletakephoto,
            ),
            SimpleDialogOption(
              child: Text("Image from gallary"),
              onPressed: handlechoosephoto,
            ),
            SimpleDialogOption(
              child: Text("cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  // compressImage() async {
  //   Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
  //   final compressedImageFile = File(path)
  //     .writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     file = compressedImageFile;
  //   });
  // }

  Future<String> uploadImage(imageFile) async {
    String jwt = await storage.read(key: "jwt");
    String fileName = imageFile.path;
    var request = http.MultipartRequest(
        'POST', Uri.parse(server_ip + 'api/upload/announcement/'));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    var res = await request.send();
    print(res.reasonPhrase);
    print(res.statusCode);
    var result = await res.stream.bytesToString();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    postTypeFontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return BaseView<AnnouncementPageModel>(
      onModelReady: (model) => model.getUserData(),
      builder: (context, model, child) {
        isPosting = model.state == ViewState.Idle ? false : true;
        return Scaffold(
          key: _scaffoldKey,
          appBar: TopBar(
            onTitleTapped: () {},
            child: kBackBtn,
            onPressed: () {
              if (!isPosting) kbackBtn(context);
            },
            title: string.create_post,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (isReadyToPost) floatingButtonPressed(model, context);
            },
            backgroundColor: isReadyToPost
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
            child: model.state == ViewState.Busy
                ? SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 20,
                  )
                : Icon(Icons.check),
          ),
          body: InkWell(
            // splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _focusNode.unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // height: 165,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              string.this_post_is_for,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: RawMaterialButton(
                                    elevation: 0,
                                    constraints: BoxConstraints(minHeight: 50),
                                    child: Text(
                                      'GLOBAL POST',
                                      style: TextStyle(
                                        color: postType == 'GLOBAL'
                                            ? Colors.white
                                            : postTypeFontColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        postType = 'GLOBAL';
                                      });
                                    },
                                    fillColor: postType == 'GLOBAL'
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                                Expanded(
                                  child: RawMaterialButton(
                                    elevation: 0,
                                    constraints: BoxConstraints(minHeight: 50),
                                    child: Text(
                                      'SPECIFIC',
                                      style: TextStyle(
                                        color: postType == 'SPECIFIC'
                                            ? Colors.white
                                            : postTypeFontColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        postType = 'SPECIFIC';
                                      });
                                    },
                                    fillColor: postType == 'SPECIFIC'
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          postType == 'SPECIFIC'
                              ? SizedBox(
                                  height: 5,
                                )
                              : Container(),
                          postType == 'SPECIFIC'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      // width: MediaQuery.of(context).size.width / 2.2,
                                      child: TextField(
                                        enabled: !isPosting,
                                        controller: _standardController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                          hintText: string.standard_hint,
                                          labelText: string.standard,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      // width: MediaQuery.of(context).size.width / 2.2,
                                      child: TextField(
                                        enabled: !isPosting,
                                        controller: _divisionController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                          hintText: string.standard_hint,
                                          labelText: string.division,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    postType == 'SPECIFIC'
                        ? SizedBox(
                            height: 5,
                          )
                        : Container(),
                    Container(
                      // height: 60,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'EVENT',
                                style: TextStyle(
                                  color:
                                      announcementType == AnnouncementType.EVENT
                                          ? Colors.white
                                          : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (model.state == ViewState.Idle)
                                    announcementType = AnnouncementType.EVENT;
                                });
                              },
                              color: announcementType == AnnouncementType.EVENT
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'CIRCULAR',
                                style: TextStyle(
                                  color: announcementType ==
                                          AnnouncementType.CIRCULAR
                                      ? Colors.white
                                      : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (model.state == ViewState.Idle)
                                    announcementType =
                                        AnnouncementType.CIRCULAR;
                                });
                              },
                              color:
                                  announcementType == AnnouncementType.CIRCULAR
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'ACTIVITY',
                                style: TextStyle(
                                  color: announcementType ==
                                          AnnouncementType.ACTIVITY
                                      ? Colors.white
                                      : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (model.state == ViewState.Idle)
                                    announcementType =
                                        AnnouncementType.ACTIVITY;
                                });
                              },
                              color:
                                  announcementType == AnnouncementType.ACTIVITY
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 300, minHeight: 0),
                      child: path == 'default'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  height: 100,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Icon(FontAwesomeIcons.camera),
                                  onPressed: () async {
                                    selectImage(context);
                                  },
                                ),
                              ],
                            )
                          : Card(
                              elevation: 4,
                              child: Container(
                                // constraints:
                                //     BoxConstraints(maxHeight: 300, minHeight: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    path != "default"
                                        ? Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(file),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Positioned(
                                      right: -0,
                                      bottom: -0,
                                      child: Card(
                                        elevation: 10,
                                        shape: kCardCircularShape,
                                        child: MaterialButton(
                                          minWidth: 20,
                                          height: 10,
                                          onPressed: () {
                                            setState(
                                              () {
                                                path = "default";
                                                file = null;
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      // color: Colors.blueAccent.withOpacity(0.5),
                      child: TextField(
                        controller: _captionController,
                        enabled: !isPosting,
                        focusNode: _focusNode,
                        maxLength: null,
                        onChanged: (caption) {
                          setState(() {
                            isReadyToPost = caption == '' ? false : true;
                          });
                        },
                        maxLines: 50,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: string.type_your_stuff_here,
                          labelText: string.caption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
