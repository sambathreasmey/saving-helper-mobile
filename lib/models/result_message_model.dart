class ResultMessage {
  int? code;
  String? message;
  int? status;

  ResultMessage({this.code, this.message, this.status});

  factory ResultMessage.fromJson(Map<String, dynamic> json) {
    return ResultMessage(
      code: json['code'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'status': status,
    };
  }

}