class DashboardModel {
  String message;
  bool status;
  Data data;

  DashboardModel({this.message, this.status, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Promotion> promotion;
  List<ImpotentNews> impotentNews;
  List<UpcomingEvents> upcomingEvents;

  Data({this.promotion, this.impotentNews, this.upcomingEvents});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['promotion'] != null) {
      promotion = new List<Promotion>();
      json['promotion'].forEach((v) {
        promotion.add(new Promotion.fromJson(v));
      });
    }
    if (json['impotent_news'] != null) {
      impotentNews = new List<ImpotentNews>();
      json['impotent_news'].forEach((v) {
        impotentNews.add(new ImpotentNews.fromJson(v));
      });
    }
    if (json['upcoming_events'] != null) {
      upcomingEvents = new List<UpcomingEvents>();
      json['upcoming_events'].forEach((v) {
        upcomingEvents.add(new UpcomingEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promotion != null) {
      data['promotion'] = this.promotion.map((v) => v.toJson()).toList();
    }
    if (this.impotentNews != null) {
      data['impotent_news'] = this.impotentNews.map((v) => v.toJson()).toList();
    }
    if (this.upcomingEvents != null) {
      data['upcoming_events'] =
          this.upcomingEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Promotion {
  String sId;
  String description;
  String type;
  String updatedAt;
  String createdAt;
  String image;

  Promotion(
      {this.sId,
      this.description,
      this.type,
      this.updatedAt,
      this.createdAt,
      this.image});

  Promotion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    description = json['description'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['description'] = this.description;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    return data;
  }
}

class ImpotentNews {
  String sId;
  String news;
  String image;
  String updatedAt;
  String createdAt;

  ImpotentNews(
      {this.sId, this.news, this.image, this.updatedAt, this.createdAt});

  ImpotentNews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    news = json['news'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['news'] = this.news;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class UpcomingEvents {
  String id;
  String title;
  String startDate;
  List<String> interesUsers;

  UpcomingEvents({this.id, this.title, this.startDate, this.interesUsers});

  UpcomingEvents.fromJson(Map<String, dynamic> json) {
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
