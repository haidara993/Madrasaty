import 'package:get_it/get_it.dart';
import 'package:madrasatymobile/core/services/AnnouncementServices.dart';
import 'package:madrasatymobile/core/services/AssignmentServices.dart';
import 'package:madrasatymobile/core/services/AuthService.dart';
import 'package:madrasatymobile/core/services/ProfileService.dart';
import 'package:madrasatymobile/core/services/repository_calendarific.dart';
import 'package:madrasatymobile/core/viewModel/AssignmentPageModel.dart';
import 'package:madrasatymobile/core/viewModel/LoginPageModel.dart';
import 'package:madrasatymobile/core/viewModel/ProfilePageModel.dart';
import 'package:madrasatymobile/core/viewmodel/HolidayModel.dart';

import 'core/helpers/shared_preferences_helper.dart';
import 'core/viewModel/Announcement/AnnouncementPageModel.dart';
import 'core/viewModel/Announcement/CreateAnnouncementModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AnnouncementServices());
  locator.registerFactory(() => CreateAnnouncementModel());
  locator.registerFactory(() => AnnouncementPageModel());

  locator.registerLazySingleton(() => AssignmentServices());
  locator.registerFactory(() => AssignmentPageModel());

  locator.registerLazySingleton(() => SharedPreferencesHelper());

  locator.registerLazySingleton(() => RepositoryCalendarific());
  locator.registerFactory(() => HolidayModel());

  locator.registerLazySingleton(() => AuthService());
  locator.registerFactory(() => LoginPageModel());

  locator.registerLazySingleton(() => ProfileService());
  locator.registerLazySingleton(() => ProfilePageModel());
}
