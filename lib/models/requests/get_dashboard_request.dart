class GetDashboardRequest {
  final String channelId;

  GetDashboardRequest({required this.channelId});

  factory GetDashboardRequest.fromJson(Map<String, dynamic> json) {
    return GetDashboardRequest(
      channelId: json['channel_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
    };
  }
}