class GetDashboardRequest {
  final String channelId;
  final String userId;
  final String groupId;

  GetDashboardRequest({required this.channelId, required this.userId, required this.groupId});

  factory GetDashboardRequest.fromJson(Map<String, dynamic> json) {
    return GetDashboardRequest(
      channelId: json['channel_id'],
      userId: json['user_id'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'user_id': userId,
      'group_id': groupId,
    };
  }
}