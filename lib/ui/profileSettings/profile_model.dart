class ProfileModel {
  String message;
  bool status;
  Data data;

  ProfileModel({this.message, this.status, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  String sId;
  String email;
  String userType;
  UserInformations userInformations;
  String updatedAt;
  String createdAt;
  String image;

  Data(
      {this.sId,
        this.email,
        this.userType,
        this.userInformations,
        this.updatedAt,
        this.createdAt,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
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
