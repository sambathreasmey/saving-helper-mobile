class SavingPlanCalculateResponse {
  int? code;
  Data? data;
  String? message;
  int? status;

  SavingPlanCalculateResponse(
      {this.code, this.data, this.message, this.status});

  SavingPlanCalculateResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  double? daily;
  double? monthly;
  double? weekly;

  Data({this.daily, this.monthly, this.weekly});

  Data.fromJson(Map<String, dynamic> json) {
    daily = json['daily'];
    monthly = json['monthly'];
    weekly = json['weekly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daily'] = this.daily;
    data['monthly'] = this.monthly;
    data['weekly'] = this.weekly;
    return data;
  }
}