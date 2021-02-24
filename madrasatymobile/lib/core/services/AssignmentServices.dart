import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:madrasatymobile/UI/Utility/constants.dart';
import 'package:madrasatymobile/core/Models/Assignment.dart';
import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/core/services/Services.dart';
import 'package:madrasatymobile/locator.dart';
import 'package:madrasatymobile/main.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class AssignmentServices extends Services {
  User user;
  List<Assignment> assignments = new List<Assignment>();

  SharedPreferencesHelper _sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  Future<int> uploadAssignment(Assignment assignment) async {
    Map data = {
      "UserId": assignment.userId,
      "Title": assignment.title,
      "Details": assignment.details,
      "DivisionId": assignment.divisionId,
      "StandardId": assignment.standardId,
      "TimeStamp": assignment.timeStamp,
      "Url": assignment.url,
      "Subject": assignment.subject
    };

    String jwt = await storage.read(key: "jwt");

    final Response response = await post(
      server_ip + 'api/assignment/',
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );
    return response.statusCode;

    // await getSchoolCode();

    // String extension = p.extension(assignment.url);

    // if (extension == '.pdf') {
    //   assignment.type = 'PDF';
    // } else {
    //   assignment.type = 'Image';
    // }

    // String fileName =
    //     createCryptoRandomString(8) + createCryptoRandomString(8) + extension;

    // assignment.url =
    //     await _storageServices.uploadAssignment(assignment.url, fileName);

    // String filePath = '${Services.country}/$schoolCode/Assignments/$fileName';
    // assignment.path = filePath;

    // Map assignmentMap = assignment.toJson();

    // var body = json.encode({
    //   "schoolCode": schoolCode.toUpperCase(),
    //   "country": Services.country,
    //   "assignment": assignmentMap
    // });

    // print('Upload Assignmnet body : ' + body.toString());

    // final response =
    //     await http.post(addAssignmentUrl, body: body, headers: headers);

    // if (response.statusCode == 200) {
    //   print("Assignment added Succesfully");
    //   print(json.decode(response.body).toString());
    // } else {
    //   print("Assignment adding failed");
    // }
  }

  Future<List<Assignment>> getAssignments() async {
    var userDataModel = await _sharedPreferencesHelper.getUserDataModel();
    final jsonData = json.decode(userDataModel);
    user = User.fromJson(jsonData);

    var jwt = await storage.read(key: "jwt");
    final Response response = await get(
      server_ip + 'api/assignment/' + user.divisionId.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        HttpHeaders.authorizationHeader: 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body).cast<Map<String, dynamic>>();
      assignments =
          res.map<Assignment>((json) => Assignment.fromJson(json)).toList();

      return assignments;
    } else {
      return [];
    }
  }
}
