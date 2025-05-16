class DepositSavingRequest {
  final String channelId;
  final String transactionDate;
  final String amount;
  final String transactionDesc;
  final String userId;
  final String currencyType;
  final String transactionType;
  final String groupId;

  DepositSavingRequest({required this.channelId, required this.transactionDate, required this.amount, required this.transactionDesc, required this.userId, required this.currencyType, required this.transactionType, required this.groupId});

  factory DepositSavingRequest.fromJson(Map<String, dynamic> json) {
    return DepositSavingRequest(
      channelId: json['channel_id'],
      transactionDate: json['transaction_date'],
      amount: json['amount'],
      transactionDesc: json['transaction_desc'],
      userId: json['user_id'],
      currencyType: json['currency_type'],
      transactionType: json['transaction_type'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'transaction_date': transactionDate,
      'amount': amount,
      'transaction_desc': transactionDesc,
      'user_id': userId,
      'currency_type': currencyType,
      'transaction_type': transactionType,
      'group_id': groupId,
    };
  }
}