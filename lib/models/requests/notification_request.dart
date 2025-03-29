class NotificationRequest {
  final String channelId;

  NotificationRequest({required this.channelId});

  factory NotificationRequest.fromJson(Map<String, dynamic> json) {
    return NotificationRequest(
      channelId: json['channel_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
    };
  }
}