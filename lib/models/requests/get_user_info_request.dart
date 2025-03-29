class GetUserInfoRequest {
  final String channelId;
  final String userName;

  GetUserInfoRequest({required this.channelId, required this.userName});

  factory GetUserInfoRequest.fromJson(Map<String, dynamic> json) {
    return GetUserInfoRequest(
      channelId: json['channel_id'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'user_name': userName,
    };
  }
}