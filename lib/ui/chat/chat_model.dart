class ChatModel {
  String message;
  bool status;
  List<MessageList> messageList;

  ChatModel({this.message, this.status, this.messageList});

  ChatModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['message_list'] != null) {
      messageList = new List<MessageList>();
      json['message_list'].forEach((v) {
        messageList.add(new MessageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.messageList != null) {
      data['message_list'] = this.messageList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class MessageList {
  String id;
  String messageBody;
  String messageDate;
  PostedBy postedBy;
  PostedFor postedFor;

  MessageList(
      {this.id,
        this.messageBody,
        this.messageDate,
        this.postedBy,
        this.postedFor});

  MessageList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageBody = json['message_body'];
    messageDate = json['message_date'];
    postedBy = json['posted_by'] != null
        ? new PostedBy.fromJson(json['posted_by'])
        : null;
    postedFor = json['posted_for'] != null
        ? new PostedFor.fromJson(json['posted_for'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message_body'] = this.messageBody;
    data['message_date'] = this.messageDate;
    if (this.postedBy != null) {
      data['posted_by'] = this.postedBy.toJson();
    }
    if (this.postedFor != null) {
      data['posted_for'] = this.postedFor.toJson();
    }
    return data;
  }
}

class PostedBy {
  String sId;
  String name;
  String email;
  String userType;
  String updatedAt;
  String createdAt;

  PostedBy(
      {this.sId,
        this.name,
        this.email,
        this.userType,
        this.updatedAt,
        this.createdAt});

  PostedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    userType = json['user_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class PostedFor {
  String sId;
  String email;
  String userType;
  UserInformations userInformations;
  String updatedAt;
  String createdAt;
  String image;
  int otp;

  PostedFor(
      {this.sId,
        this.email,
        this.userType,
        this.userInformations,
        this.updatedAt,
        this.createdAt,
        this.image,
        this.otp});

  PostedFor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    userType = json['user_type'];
    userInformations = json['user_informations'] != null
        ? new UserInformations.fromJson(json['user_informations'])
        : null;
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    image = json['image'];
    otp = json['otp'];
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
    data['otp'] = this.otp;
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
