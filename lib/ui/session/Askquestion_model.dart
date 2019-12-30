class AskQuestion {
  String message;
  bool status;
  List<Data> data;

  AskQuestion({this.message, this.status, this.data});

  AskQuestion.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String image;
  String name;
  String question;

  Data({this.image, this.name, this.question});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['question'] = this.question;
    return data;
  }
}
