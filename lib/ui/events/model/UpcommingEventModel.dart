class UpcommingEventModel {
  String message;
  bool status;
  List<UpcommingEvents> upcommingEvents;

  UpcommingEventModel({this.message, this.status, this.upcommingEvents});

  UpcommingEventModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['upcomming_events'] != null) {
      upcommingEvents = new List<UpcommingEvents>();
      json['upcomming_events'].forEach((v) {
        upcommingEvents.add(new UpcommingEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.upcommingEvents != null) {
      data['upcomming_events'] =
          this.upcommingEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcommingEvents {
  String id;
  String title;
  String startDate;
  List<String> interesUsers;

  UpcommingEvents({this.id, this.title, this.startDate, this.interesUsers});

  UpcommingEvents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startDate = json['start_date'];
    interesUsers = json['interes_users'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['interes_users'] = this.interesUsers;
    return data;
  }
}
