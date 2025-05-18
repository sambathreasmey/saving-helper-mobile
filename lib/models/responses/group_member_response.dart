class GroupMemberResponse {
  int? code;
  List<Data>? data;
  String? message;
  int? status;

  GroupMemberResponse({this.code, this.data, this.message, this.status});

  GroupMemberResponse.fromJson(Map<String, dynamic> json) {
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
  int? groupId;
  String? invitedBy;
  String? joinedAt;
  String? role;
  UserDetail? userDetail;
  String? userId;

  Data(
      {this.groupId,
        this.invitedBy,
        this.joinedAt,
        this.role,
        this.userDetail,
        this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    invitedBy = json['invited_by'];
    joinedAt = json['joined_at'];
    role = json['role'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['invited_by'] = this.invitedBy;
    data['joined_at'] = this.joinedAt;
    data['role'] = this.role;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    data['user_id'] = this.userId;
    return data;
  }
}

class UserDetail {
  int? attempt;
  String? createOn;
  String? emailAddress;
  String? fullName;
  String? id;
  String? role;
  int? status;
  String? updateOn;
  String? userName;

  UserDetail(
      {this.attempt,
        this.createOn,
        this.emailAddress,
        this.fullName,
        this.id,
        this.role,
        this.status,
        this.updateOn,
        this.userName});

  UserDetail.fromJson(Map<String, dynamic> json) {
    attempt = json['attempt'];
    createOn = json['create_on'];
    emailAddress = json['email_address'];
    fullName = json['full_name'];
    id = json['id'];
    role = json['role'];
    status = json['status'];
    updateOn = json['update_on'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attempt'] = this.attempt;
    data['create_on'] = this.createOn;
    data['email_address'] = this.emailAddress;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
    data['role'] = this.role;
    data['status'] = this.status;
    data['update_on'] = this.updateOn;
    data['user_name'] = this.userName;
    return data;
  }
}
