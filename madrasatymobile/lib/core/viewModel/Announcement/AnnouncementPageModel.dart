import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/services/AnnouncementServices.dart';
import 'package:madrasatymobile/core/viewmodel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class AnnouncementPageModel extends BaseModel {
  AnnouncementServices _announcementServices = locator<AnnouncementServices>();

  List<Announcement> get announcements => _announcementServices.announcements;
  AnnouncementPageModel();

  getAnnouncements() async {
    setState(ViewState.Busy);
    await _announcementServices.getAnnouncements();
    setState(ViewState.Idle);
    print(announcements.length);
    // return announcements;
  }

  getUserData() async {
    setState(ViewState.Busy);
    // await announcementServices.init();
    setState(ViewState.Idle);
  }

  Future<int> postAnnouncement(Announcement announcement) async {
    setState(ViewState.Busy);
    int response = await _announcementServices.postAnnouncement(announcement);
    print(response);
    setState(ViewState.Idle);
    return response;
  }

  onRefresh(int divId) async {
    _announcementServices.announcements.clear();
    await getAnnouncements();
  }

  @override
  void dispose() {
    _announcementServices.announcements.clear();
    super.dispose();
  }
}
