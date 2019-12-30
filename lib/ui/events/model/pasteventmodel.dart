class PastEventModel {
  String message;
  bool status;
  List<PastEvents> pastEvents;

  PastEventModel({this.message, this.status, this.pastEvents});

  PastEventModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['past_events'] != null) {
      pastEvents = new List<PastEvents>();
      json['past_events'].forEach((v) {
        pastEvents.add(new PastEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.pastEvents != null) {
      data['past_events'] = this.pastEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PastEvents {
  String id;
  String title;
  String startDate;
  List<String> interesUsers;

  PastEvents({this.id, this.title, this.startDate, this.interesUsers});

  PastEvents.fromJson(Map<String, dynamic> json) {
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
