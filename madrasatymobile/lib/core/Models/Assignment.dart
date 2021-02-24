class Assignment {
  int userId;
  int divisionId;
  String subject;
  int standardId;
  String timeStamp;
  String url;
  String type;
  String details;
  int id;
  String title;

  Assignment(
      {this.userId,
      this.title,
      this.divisionId,
      this.subject,
      this.standardId,
      this.timeStamp,
      this.url,
      this.details,
      this.id});

  Assignment.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    divisionId = json['divisionId'];
    subject = json['subject'];
    type = json['type'] ?? '';
    standardId = json['standardId'];
    timeStamp = json['timeStamp'];
    url = json['url'];
    details = json['details'] ?? '';
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['divisionId'] = this.divisionId;
    data['type'] = this.type;
    data['subject'] = this.subject;
    data['standardId'] = this.standardId;
    data['url'] = this.url;
    data['details'] = this.details;
    data['id'] = this.id;
    return data;
  }
}
