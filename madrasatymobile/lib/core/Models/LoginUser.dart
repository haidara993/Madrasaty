class LoginUser {
  String username;
  String password;

  LoginUser({this.username, this.password});

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      username: json['UserName'],
      password: json['Password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.username;
    data['Password'] = this.password;
    return data;
  }
}
