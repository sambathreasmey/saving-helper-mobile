class DeleteRepayLoanRequest {
  final String channelId;
  final String transactionId;
  final String repayId;

  DeleteRepayLoanRequest({required this.channelId, required this.transactionId, required this.repayId});

  factory DeleteRepayLoanRequest.fromJson(Map<String, dynamic> json) {
    return DeleteRepayLoanRequest(
      channelId: json['channel_id'],
      transactionId: json['transaction_id'],
      repayId: json['repay_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'transaction_id': transactionId,
      'repay_id': repayId,
    };
  }
}