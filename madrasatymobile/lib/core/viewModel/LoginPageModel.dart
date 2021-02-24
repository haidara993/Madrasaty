import 'package:madrasatymobile/core/Models/User.dart';
import 'package:madrasatymobile/core/services/AuthService.dart';
import 'package:madrasatymobile/core/viewModel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class LoginPageModel extends BaseModel {
  final _authenticationService = locator<AuthService>();
  User _loggedInUser;
  String currentLoggingStatus = 'Please wait';
  User get loggedInUser => _loggedInUser;
}
