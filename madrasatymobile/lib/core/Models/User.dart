class User {
  int id;
  String photoUrl;
  String email;
  String division;
  int divisionId;
  String enrollNo;
  String displayName;
  String standard;
  int standardId;
  String dob;
  String guardianName;
  String bloodGroup;
  String mobileNo;
  bool isVerified;
  String jwt;

  User({
    this.id,
    this.photoUrl,
    this.email,
    this.division,
    this.divisionId,
    this.enrollNo,
    this.displayName,
    this.standard,
    this.standardId,
    this.dob,
    this.guardianName,
    this.bloodGroup,
    this.mobileNo,
    this.isVerified,
    this.jwt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      photoUrl: json["photoUrl"],
      email: json["email"],
      division: json["division"],
      divisionId: json["divisionId"],
      enrollNo: json["enrollNo"],
      displayName: json["displayName"],
      standard: json["standard"],
      standardId: json["standardId"],
      dob: json["dob"],
      guardianName: json["guardianName"],
      bloodGroup: json["bloodGroup"],
      mobileNo: json["mobileNo"],
      isVerified: json["isVerified"],
      jwt: json["jwt"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["photoUrl"] = this.photoUrl;
    data["email"] = this.email;
    data["division"] = this.division;
    data["divisionId"] = this.divisionId;
    data["enrollNo"] = this.enrollNo;
    data["displayName"] = this.displayName;
    data["standard"] = this.standard;
    data["standardId"] = this.standardId;
    data["dob"] = this.dob;
    data["guardianName"] = this.guardianName;
    data["bloodGroup"] = this.bloodGroup;
    data["mobileNo"] = this.mobileNo;
    data["isVerified"] = this.isVerified;
    return data;
  }
}

class AuthUserDetails {
  String accessToken;
  int expiresIn;
  User userDetails;
  AuthUserDetails._({this.accessToken, this.expiresIn, this.userDetails});
  factory AuthUserDetails.fromJson(Map<String, dynamic> json) {
    // print("<<<<<<<<<<< user deatils"+json["userDetails"]);
    return new AuthUserDetails._(
        accessToken: json["accessToken"],
        expiresIn: json["expires_in"],
        userDetails: User.fromJson(json["userDetails"]));
  }
  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'expiresIn': expiresIn,
        'userDetails': userDetails
      };
}
