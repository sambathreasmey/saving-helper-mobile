class NotificationRequest {
  final String channelId;
  final String groupId;

  NotificationRequest({required this.channelId, required this.groupId});

  factory NotificationRequest.fromJson(Map<String, dynamic> json) {
    return NotificationRequest(
      channelId: json['channel_id'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'group_id': groupId,
    };
  }
}