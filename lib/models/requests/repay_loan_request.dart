class RepayLoanRequest {
  final String channelId;
  final String transactionId;
  final String repayAmount;
  final String repayDate;
  final String repayDesc;

  RepayLoanRequest({required this.channelId, required this.transactionId, required this.repayAmount, required this.repayDate, required this.repayDesc});

  factory RepayLoanRequest.fromJson(Map<String, dynamic> json) {
    return RepayLoanRequest(
      channelId: json['channel_id'],
      transactionId: json['transaction_id'],
      repayAmount: json['repay_amount'],
      repayDate: json['repay_date'],
      repayDesc: json['repay_desc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'transaction_id': transactionId,
      'repay_amount': repayAmount,
      'repay_date': repayDate,
      'repay_desc': repayDesc,
    };
  }
}