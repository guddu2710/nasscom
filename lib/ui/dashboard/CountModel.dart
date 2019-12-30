class CountModel {
  String messgae;
  bool status;
  int count;

  CountModel({this.messgae, this.status, this.count});

  CountModel.fromJson(Map<String, dynamic> json) {
    messgae = json['messgae'];
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messgae'] = this.messgae;
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}
