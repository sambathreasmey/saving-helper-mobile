import 'package:saving_helper/models/result_message_model.dart';
import 'package:saving_helper/models/user_info_model.dart';

class GetUserInfoResponse {
  ResultMessage? resultMessage;
  UserInfo? data;

  GetUserInfoResponse({this.resultMessage, this.data});

  factory GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    return GetUserInfoResponse(
      resultMessage: json['result_message'] != null
          ? ResultMessage.fromJson(json['result_message'])
          : null,
      data: json['data'] != null && json['data'].isNotEmpty
          ? UserInfo.fromJson(json['data'][0]) // Get the first element (index 0) of the 'data' list
          : null,
    );
  }
}
