class GetReportRequest {
  final String channelId;
  final String reportType;

  GetReportRequest({required this.channelId, required this.reportType});

  factory GetReportRequest.fromJson(Map<String, dynamic> json) {
    return GetReportRequest(
      channelId: json['channel_id'],
      reportType: json['report_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'report_type': reportType,
    };
  }
}