import 'package:madrasatymobile/core/Models/Announcement.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/services/AnnouncementServices.dart';
import 'package:madrasatymobile/core/viewmodel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class AnnouncementPageModel extends BaseModel {
  AnnouncementServices _announcementServices = locator<AnnouncementServices>();

  List<Announcement> announcements = [];
  AnnouncementPageModel();

  Future<List<Announcement>> getAnnouncements() async {
    setState(ViewState.Busy);
    announcements = await _announcementServices.getAnnouncements();
    setState(ViewState.Idle);
    print(announcements.length);
    return announcements;
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
