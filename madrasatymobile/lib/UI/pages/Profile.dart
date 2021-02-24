import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/UI/BaseView.dart';
import 'package:madrasatymobile/UI/Utility/Resources.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/UI/pages/Home.dart';
import 'package:madrasatymobile/UI/widgets/TopBar.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/enums/UserType.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/viewModel/ProfilePageModel.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:madrasatymobile/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  static const id = 'ProfilePage';
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime dateOfBirth;
  UserType userType = UserType.Unkown;
  bool guardiansPanel = false;
  String path = 'default';
  // String tempPath = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = '';
  String _enrollNo = '';
  int _standard;
  int _division;
  String _guardianName = '';
  String _bloodGroup = '';
  String _dob = '';
  String _mobileNo = '';
  int a = 0;

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  User user;
  int loggedUserId;
  Future<User> getUser() async {
    _sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
      final jsonData = json.decode(userDataModel);
      // print("sadasdasdasdadasda" + userDataModel);
      user = User.fromJson(jsonData);
      loggedUserId = user.id;
    });
    String jwt = await storage.read(key: "jwt");
    final http.Response response = await http.get(
      server_ip + 'api/auth/get/' + loggedUserId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = await json.decode(response.body);

      user = User.fromJson(jsonData);
      _sharedPreferencesHelper.setUserDataModel(user);

      return user;
    }
    return user;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
        _dob = picked.toLocal().toString().substring(0, 10);
      });
    }
  }

  File file;
  handletakephoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    final tempDir = await getTemporaryDirectory();
    path = tempDir.path;
    if (file != null) {
      setState(() {
        this.file = file;
      });
    }
  }

  handlechoosephoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    final tempDir = await getTemporaryDirectory();
    path = tempDir.path;
    if (file != null) {
      setState(() {
        this.file = file;
      });
    }
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

  Future<String> uploadImage(imageFile) async {
    String jwt = await storage.read(key: "jwt");
    String fileName = imageFile.path;
    var request = http.MultipartRequest(
        'POST', Uri.parse(server_ip + 'api/upload/user/' + user.id.toString()));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    var res = await request.send();
    // print(res.reasonPhrase);
    // print(res.statusCode);
    var result = await res.stream.bytesToString();

    return result;
  }

  ImageProvider<dynamic> setImage() {
    if (path.contains('http')) {
      return NetworkImage(path);
    } else if (path == 'default' || path == null) {
      return AssetImage(assetsString.student_welcome);
    } else {
      return FileImage(file);
    }
  }

  floatingButoonPressed(var model, UserType userType, User user) async {
    int res;
    if (file != null) {
      // await compressImage();
      path = await uploadImage(file);
      // print(path);
      kbackBtn(context);
    }
    // var firebaseUser = Provider.of<FirebaseUser>(context, listen: false);

    if (_bloodGroup.isEmpty ||
        _name.isEmpty ||
        _dob.isEmpty ||
        _guardianName.isEmpty ||
        _mobileNo.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(ksnackBar(
          context, 'You Need to fill all the details and a profile Photo'));
    } else {
      if (model.state == ViewState.Idle) {
        res = await model.setUserProfileData(
          user: User(
            bloodGroup: _bloodGroup.trim(),
            displayName: _name.trim(),
            divisionId: _division,
            division: model.userProfile.division,
            dob: _dob.trim(),
            guardianName: _guardianName.trim(),
            mobileNo: _mobileNo.trim(),
            standardId: _standard,
            standard: model.userProfile.standard,
            enrollNo: _enrollNo,
            email: model.userProfile.email,
            id: user.id,
            photoUrl: path,
          ),
          userType: userType,
        );
      }
    }

    if (res == 200) {
      Navigator.pop(context);
    }
  }

  Widget buildProfilePhotoWidget(BuildContext context, ProfilePageModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: 'profileeee',
                    transitionOnUserGestures: true,
                    child: Image(
                        height: MediaQuery.of(context).size.width / 2.5,
                        width: MediaQuery.of(context).size.width / 2.5,
                        image: setImage()),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 45,
                  width: 45,
                  child: Card(
                    elevation: 5,
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black38,
                        size: 25,
                      ),
                      onPressed: () async {
                        selectImage(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userType == UserType.Student) {
      guardiansPanel = false;
    } else {
      guardiansPanel = true;
    }
    return BaseView<ProfilePageModel>(
      onModelReady: (model) => model.getUserProfileData(),
      builder: (context, model, child) {
        if (model.state == ViewState.Idle) {
          if (a == 0) {
            if (model.userProfile != null) {
              User user = model.userProfile;
              _name = user.displayName ?? '';
              _enrollNo = user.enrollNo;
              _standard = user.standardId;
              _division = user.divisionId;
              _guardianName = user.guardianName ?? '';
              _bloodGroup = user.bloodGroup ?? '';
              _dob = user.dob ?? '';
              _mobileNo = user.mobileNo ?? '';
              path = user.photoUrl;
              a++;
            }
          }
        }
        return Scaffold(
          key: _scaffoldKey,
          appBar: TopBar(
              title: "Profile",
              child: kBackBtn,
              onPressed: () {
                if (model.state ==
                    ViewState.Idle) if (Navigator.canPop(context))
                  Navigator.pop(context);
              }),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Save',
            elevation: 20,
            backgroundColor: Colors.red,
            onPressed: () async {
              floatingButoonPressed(model, userType, user);
            },
            child: model.state == ViewState.Busy
                ? SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 20,
                  )
                : Icon(Icons.check),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    model.state == ViewState.Busy
                        ? kBuzyPage(color: Theme.of(context).primaryColor)
                        : buildProfilePhotoWidget(context, model),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileFields(
                            labelText: 'Student/Teacher Name',
                            width: MediaQuery.of(context).size.width,
                            hintText: 'One which your parents gave',
                            onChanged: (name) {
                              _name = name;
                            },
                            controller: TextEditingController(text: _name),
                          ),
                          ProfileFields(
                            isEditable: false,
                            labelText: 'Student 0r Teacher Roll no',
                            width: MediaQuery.of(context).size.width,
                            hintText: 'One which school gave',
                            onChanged: (id) {
                              _enrollNo = id;
                            },
                            controller: TextEditingController(text: _enrollNo),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ProfileFields(
                                  labelText: 'Standard',
                                  onChanged: (std) {
                                    _standard = std;
                                  },
                                  hintText: '',
                                  controller: TextEditingController(
                                      text: _standard.toString()),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ProfileFields(
                                  labelText: 'Division',
                                  onChanged: (div) {
                                    _division = div;
                                  },
                                  hintText: '',
                                  controller: TextEditingController(
                                      text: _division.toString()),
                                ),
                              ),
                            ],
                          ),
                          ProfileFields(
                            width: MediaQuery.of(context).size.width,
                            hintText: 'Father\'s or Mother\'s Name',
                            labelText: 'Guardian Name',
                            onChanged: (guardianName) {
                              _guardianName = guardianName;
                            },
                            controller:
                                TextEditingController(text: _guardianName),
                          ),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await _selectDate(context);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: IgnorePointer(
                                    child: ProfileFields(
                                        labelText: "Date of birth",
                                        textInputType: TextInputType.number,
                                        onChanged: (dob) {
                                          _dob = dob;
                                        },
                                        hintText: '',
                                        controller: TextEditingController(
                                          text: _dob,
                                        )
                                        // initialText: dateOfBirth == null
                                        //     ? ''
                                        //     : dateOfBirth
                                        //         .toLocal()
                                        //         .toString()
                                        //         .substring(0, 10),
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ProfileFields(
                                  // width: MediaQuery.of(context).size.width,
                                  hintText: "your blood group",
                                  labelText: "Blood Group",
                                  onChanged: (bg) {
                                    _bloodGroup = bg;
                                  },
                                  controller:
                                      TextEditingController(text: _bloodGroup),
                                ),
                              ),
                            ],
                          ),
                          ProfileFields(
                            width: MediaQuery.of(context).size.width,
                            textInputType: TextInputType.number,
                            hintText: 'Your parents..',
                            labelText: 'Mobile No',
                            onChanged: (mobile_no) {
                              _mobileNo = mobile_no;
                            },
                            controller: TextEditingController(text: _mobileNo),
                          ),
                        ],
                      ),
                    )
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

class ProfileFields extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Function onChanged;
  final double width;
  final Function onTap;
  final TextInputType textInputType;
  final TextEditingController controller;
  final bool isEditable;

  const ProfileFields(
      {@required this.labelText,
      this.hintText,
      this.onChanged,
      this.controller,
      this.onTap,
      this.textInputType,
      this.isEditable = true,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: width == null ? MediaQuery.of(context).size.width / 2.5 : width,
      child: TextField(
        enabled: isEditable,
        onTap: onTap,
        controller: controller,
        // controller: TextEditingController(text: initialText),
        onChanged: onChanged,
        keyboardType: textInputType ?? TextInputType.text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: kTextFieldDecoration.copyWith(
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}
