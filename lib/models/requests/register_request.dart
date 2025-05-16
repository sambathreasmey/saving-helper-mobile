class RegisterRequest {
  String? userName;
  String? password;
  String? email;
  String? fullName;

  RegisterRequest({this.userName, this.password, this.email, this.fullName});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    password = json['password'];
    email = json['email'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    return data;
  }
}
