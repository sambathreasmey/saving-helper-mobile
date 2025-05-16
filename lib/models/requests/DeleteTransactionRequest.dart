class DeleteTransactionRequest {
  final String channelId;
  final String transactionId;

  DeleteTransactionRequest({required this.channelId, required this.transactionId});

  factory DeleteTransactionRequest.fromJson(Map<String, dynamic> json) {
    return DeleteTransactionRequest(
      channelId: json['channel_id'],
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'transaction_id': transactionId,
    };
  }
}