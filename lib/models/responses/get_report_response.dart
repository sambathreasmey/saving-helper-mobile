import 'package:saving_helper/models/report_model.dart';
import 'package:saving_helper/models/result_message_model.dart';

class GetReportResponse {
  ResultMessage? resultMessage;
  List<ReportModel>? reports;

  GetReportResponse({this.resultMessage, this.reports});

  factory GetReportResponse.fromJson(Map<String, dynamic> json) {
    return GetReportResponse(
      resultMessage: json['result_message'] != null
          ? ResultMessage.fromJson(json['result_message'])
          : null,
      // Check if the data is a list of reports
      reports: json['data'] != null && json['data'] is List
          ? (json['data'] as List).map((item) => ReportModel.fromJson(item)).toList()
          : null,
    );
  }
}
