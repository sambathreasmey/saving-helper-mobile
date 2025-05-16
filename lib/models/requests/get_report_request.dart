class GetReportRequest {
  final String channelId;
  final String userId;
  final String groupId;
  final String reportType;

  GetReportRequest({required this.channelId, required this.userId, required this.reportType, required this.groupId});

  factory GetReportRequest.fromJson(Map<String, dynamic> json) {
    return GetReportRequest(
      channelId: json['channel_id'],
      userId: json['user_id'],
      groupId: json['group_id'],
      reportType: json['report_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'user_id': userId,
      'group_id': groupId,
      'report_type': reportType,
    };
  }
}