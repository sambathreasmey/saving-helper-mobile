class GetUserInfoRequest {
  final String channelId;
  final String par;

  GetUserInfoRequest({required this.channelId, required this.par});

  factory GetUserInfoRequest.fromJson(Map<String, dynamic> json) {
    return GetUserInfoRequest(
      channelId: json['channel_id'],
      par: json['par'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'par': par,
    };
  }
}