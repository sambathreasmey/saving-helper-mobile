class UserInfo {
  int? attempt;
  String? channelId;
  String? createOn;
  String? emailAddress;
  String? fullName;
  String? password;
  String? role;
  int? status;
  String? updateOn;
  String? userId;
  String? userName;

  UserInfo({
    this.attempt,
    this.channelId,
    this.createOn,
    this.emailAddress,
    this.fullName,
    this.password,
    this.role,
    this.status,
    this.updateOn,
    this.userId,
    this.userName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      attempt: json['attempt'],
      channelId: json['channel_id'],
      createOn: json['create_on'],
      emailAddress: json['email_address'],
      fullName: json['full_name'],
      password: json['password'],
      role: json['role'],
      status: json['status'],
      updateOn: json['update_on'],
      userId: json['user_id'],
      userName: json['user_name'],
    );
  }
}