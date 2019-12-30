class EventDetailsModel {
  String message;
  bool status;
  Event event;
  List<Speaker> speaker;
  List<Sponsor> sponsor;
  List<Exhibitor> exhibitor;
  List<Attendess> attendess;

  EventDetailsModel(
      {this.message,
        this.status,
        this.event,
        this.speaker,
        this.sponsor,
        this.exhibitor,
        this.attendess});

  EventDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    if (json['speaker'] != null) {
      speaker = new List<Speaker>();
      json['speaker'].forEach((v) {
        speaker.add(new Speaker.fromJson(v));
      });
    }
    if (json['sponsor'] != null) {
      sponsor = new List<Sponsor>();
      json['sponsor'].forEach((v) {
        sponsor.add(new Sponsor.fromJson(v));
      });
    }
    if (json['exhibitor'] != null) {
      exhibitor = new List<Exhibitor>();
      json['exhibitor'].forEach((v) {
        exhibitor.add(new Exhibitor.fromJson(v));
      });
    }
    if (json['attendess'] != null) {
      attendess = new List<Attendess>();
      json['attendess'].forEach((v) {
        attendess.add(new Attendess.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.event != null) {
      data['event'] = this.event.toJson();
    }
    if (this.speaker != null) {
      data['speaker'] = this.speaker.map((v) => v.toJson()).toList();
    }
    if (this.sponsor != null) {
      data['sponsor'] = this.sponsor.map((v) => v.toJson()).toList();
    }
    if (this.exhibitor != null) {
      data['exhibitor'] = this.exhibitor.map((v) => v.toJson()).toList();
    }
    if (this.attendess != null) {
      data['attendess'] = this.attendess.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  String about;
  String floor;
  String room;
  String building;
  String location;
  String date;
  List<String> image;

  Event({this.about, this.floor, this.room, this.building,this.location,this.image,this.date });

  Event.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    floor = json['floor'];
    room = json['room'];
    building = json['building'];
    location=json['location'];
    date=json['date'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['floor'] = this.floor;
    data['room'] = this.room;
    data['location']=this.location;
    data['date']=this.date;
    data['building'] = this.building;
    data['image'] = this.image;
    return data;
  }
}

class Speaker {
  String sId;
  String email;
  String userType;
  UserInformations userInformations;
  String updatedAt;
  String createdAt;
  String image;

  Speaker(
      {this.sId,
        this.email,
        this.userType,
        this.userInformations,
        this.updatedAt,
        this.createdAt,
        this.image});

  Speaker.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    userType = json['user_type'];
    userInformations = json['user_informations'] != null
        ? new UserInformations.fromJson(json['user_informations'])
        : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    if (this.userInformations != null) {
      data['user_informations'] = this.userInformations.toJson();
    }
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    return data;
  }
}

class UserInformations {
  String firstName;
  String lastName;
  String phoneNo;
  String company;
  String industry;
  String designation;
  String about;
  String facebook;
  String linkedin;

  UserInformations(
      {this.firstName,
        this.lastName,
        this.phoneNo,
        this.company,
        this.industry,
        this.designation,
        this.about,
        this.facebook,
        this.linkedin});

  UserInformations.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNo = json['phone_no'];
    company = json['company'];
    industry = json['industry'];
    designation = json['designation'];
    about = json['about'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_no'] = this.phoneNo;
    data['company'] = this.company;
    data['industry'] = this.industry;
    data['designation'] = this.designation;
    data['about'] = this.about;
    data['facebook'] = this.facebook;
    data['linkedin'] = this.linkedin;
    return data;
  }
}

class Sponsor {
  String sId;
  String firstName;
  String lastName;
  String description;
  String image;
  Social social;
  String updatedAt;
  String createdAt;

  Sponsor(
      {this.sId,
        this.firstName,
        this.lastName,
        this.description,
        this.image,
        this.social,
        this.updatedAt,
        this.createdAt});

  Sponsor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    description = json['description'];
    image = json['image'];
    social =
    json['social'] != null ? new Social.fromJson(json['social']) : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.social != null) {
      data['social'] = this.social.toJson();
    }
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Social {
  String facebook;
  String twitter;

  Social({this.facebook, this.twitter});

  Social.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    return data;
  }
}

class Exhibitor {
  String sId;
  String firstName;
  String lastName;
  String title;
  String description;
  String image;
  Social social;
  String updatedAt;
  String createdAt;

  Exhibitor(
      {this.sId,
        this.firstName,
        this.lastName,
        this.title,
        this.description,
        this.image,
        this.social,
        this.updatedAt,
        this.createdAt});

  Exhibitor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    social =
    json['social'] != null ? new Social.fromJson(json['social']) : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.social != null) {
      data['social'] = this.social.toJson();
    }
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
class Attendess {
  String sId;
  String email;
  String userType;
  UserInformations userInformations;
  String updatedAt;
  String createdAt;
  String image;

  Attendess(
      {this.sId,
        this.email,
        this.userType,
        this.userInformations,
        this.updatedAt,
        this.createdAt,
        this.image});

  Attendess.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    userType = json['user_type'];
    userInformations = json['user_informations'] != null
        ? new UserInformations.fromJson(json['user_informations'])
        : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    if (this.userInformations != null) {
      data['user_informations'] = this.userInformations.toJson();
    }
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    return data;
  }
}

