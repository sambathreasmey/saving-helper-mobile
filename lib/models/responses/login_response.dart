class LoginResponse {
  int? code;
  Data? data;
  String? message;
  int? status;

  LoginResponse({this.code, this.data, this.message, this.status});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? fullName;
  List<Groups>? groups;
  List<String>? roles;
  String? userId;
  String? userName;

  Data(
      {this.email,
        this.fullName,
        this.groups,
        this.roles,
        this.userId,
        this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['full_name'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    data['roles'] = this.roles;
    data['user_id'] = this.userId;
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