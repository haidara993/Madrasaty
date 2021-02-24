import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/services/AnnouncementServices.dart';
import 'package:madrasatymobile/core/viewmodel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class CreateAnnouncementModel extends BaseModel {
  AnnouncementServices announcementServices = locator<AnnouncementServices>();

  getUserData() async {
    setState(ViewState.Busy);
    // await announcementServices.init();
    setState(ViewState.Idle);
  }

  Future<int> postAnnouncement(Announcement announcement) async {
    setState(ViewState.Busy);
    int response = await announcementServices.postAnnouncement(announcement);
    print(response);
    setState(ViewState.Idle);
    return response;
  }

  // @override
  // void dispose() {
  //   if (state == ViewState.Idle && state2 == ViewState.Idle) {
  //     super.dispose();
  //   }
  // }
}
