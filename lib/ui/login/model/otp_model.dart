class OtpModel {
  String message;
  bool status;
  int otp;

  OtpModel({this.message, this.status, this.otp});

  OtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['otp'] = this.otp;
    return data;
  }
}
