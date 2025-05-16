class GetUserInfoResponse {
  int? code;
  Data? data;
  String? message;
  int? status;

  GetUserInfoResponse({this.code, this.data, this.message, this.status});

  GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
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
  int? attempt;
  String? emailAddress;
  String? fullName;
  List<Groups>? groups;
  String? id;
  List<String>? roles;
  int? status;
  String? userName;

  Data(
      {this.attempt,
        this.emailAddress,
        this.fullName,
        this.groups,
        this.id,
        this.roles,
        this.status,
        this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    attempt = json['attempt'];
    emailAddress = json['email_address'];
    fullName = json['full_name'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    id = json['id'];
    roles = json['roles'].cast<String>();
    status = json['status'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attempt'] = this.attempt;
    data['email_address'] = this.emailAddress;
    data['full_name'] = this.fullName;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['roles'] = this.roles;
    data['status'] = this.status;
    data['user_name'] = this.userName;
    return data;
  }
}

class Groups {
  String? groupId;
  String? groupName;
  String? invitedBy;
  String? joinedAt;
  String? role;

  Groups(
      {this.groupId, this.groupName, this.invitedBy, this.joinedAt, this.role});

  Groups.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupName = json['group_name'];
    invitedBy = json['invited_by'];
    joinedAt = json['joined_at'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['invited_by'] = this.invitedBy;
    data['joined_at'] = this.joinedAt;
    data['role'] = this.role;
    return data;
  }
}