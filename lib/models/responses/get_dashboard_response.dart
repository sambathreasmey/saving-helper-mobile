import 'package:saving_helper/models/dashboard_model.dart';
import 'package:saving_helper/models/result_message_model.dart';

class GetDashboardResponse {
  ResultMessage? resultMessage;
  DashboardModel? dashboard;

  GetDashboardResponse({this.resultMessage, this.dashboard});

  factory GetDashboardResponse.fromJson(Map<String, dynamic> json) {
    return GetDashboardResponse(
      resultMessage: json['result_message'] != null
          ? ResultMessage.fromJson(json['result_message'])
          : null,
      dashboard: json['dashboard'] != null && json['dashboard'].isNotEmpty
          ? DashboardModel.fromJson(json['dashboard'])
          : null,
    );
  }
}