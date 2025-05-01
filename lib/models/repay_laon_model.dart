class RepayLoanDetail {
  double? repayAmount;
  String? repayDate;
  String? repayDesc;
  String? repayId;

  RepayLoanDetail({
    this.repayAmount,
    this.repayDate,
    this.repayDesc,
    this.repayId,
  });

  factory RepayLoanDetail.fromJson(Map<String, dynamic> json) {
    return RepayLoanDetail(
      repayAmount: json['repay_amount'],
      repayDate: json['repay_date'],
      repayDesc: json['repay_desc'],
      repayId: json['repay_id'],
    );
  }
}