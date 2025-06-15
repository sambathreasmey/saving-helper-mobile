class GetGoalResponse {
  int? code;
  List<Data>? data;
  String? message;
  int? status;

  GetGoalResponse({this.code, this.data, this.message, this.status});

  GetGoalResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? createdAt;
  String? createdBy;
  double? goalAmount;
  int? groupId;
  String? groupName;

  Data(
      {this.createdAt,
        this.createdBy,
        this.goalAmount,
        this.groupId,
        this.groupName});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    goalAmount = json['goal_amount'];
    groupId = json['group_id'];
    groupName = json['group_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['goal_amount'] = this.goalAmount;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    return data;
  }
}
