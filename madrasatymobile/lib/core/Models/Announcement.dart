// import 'package:madrasaty/UI/Utility/Resources.dart';

class Announcement {
  int id;
  String caption;
  int userId;
  String userPhotoUrl;
  String displayName;
  int standardId;
  int divisionId;
  String timestamp;
  String photoUrl;
  String anouncementType;

  Announcement({
    this.id,
    this.caption,
    this.userId,
    this.userPhotoUrl,
    this.displayName,
    this.standardId,
    this.divisionId,
    this.timestamp,
    this.photoUrl,
    this.anouncementType,
  });

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caption = json['caption'] ?? '';
    userId = json['userId'];
    userPhotoUrl = json['userPhotoUrl'];
    displayName = json['displayName'];
    divisionId = json['divisionId'];
    standardId = json['standardId'];
    timestamp = json['timestamp'];
    photoUrl = json['photoUrl'] ?? '';
    anouncementType = json['anouncementType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['caption'] = this.caption;
    data['userId'] = this.userId;
    data['userPhotoUrl'] = this.userPhotoUrl;
    data['displayName'] = this.displayName;
    data['divisionId'] = this.divisionId;
    data['timestamp'] = this.timestamp;
    data['standardId'] = this.standardId;
    data['photoUrl'] = this.photoUrl;
    data['anouncementType'] = this.anouncementType;

    return data;
  }
}
