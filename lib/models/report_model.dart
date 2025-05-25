import 'package:saving_helper/models/repay_laon_model.dart';

class ReportModel {
  double? amount;
  String? currencyType;
  double? remainBalance;
  String? transactionDate;
  String? transactionDesc;
  String? transactionId;
  String? transactionType;
  String? userId;
  bool? isCompleted;
  String? remainDate;
  String? createdBy;
  List<RepayLoanDetail>? repayLoanDetails;

  ReportModel({
    this.amount,
    this.currencyType,
    this.remainBalance,
    this.transactionDate,
    this.transactionDesc,
    this.transactionId,
    this.transactionType,
    this.userId,
    this.isCompleted,
    this.repayLoanDetails,
    this.remainDate,
    this.createdBy
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      amount: json['amount'],
      currencyType: json['currency_type'],
      remainBalance: json['remain_balance'],
      transactionDate: json['transaction_date'],
      transactionDesc: json['transaction_desc'],
      transactionId: json['transaction_id'],
      transactionType: json['transaction_type'],
      userId: json['user_id'],
      isCompleted: json['is_completed'],
      remainDate: json['remain_date'],
      createdBy: json['created_by'],
      repayLoanDetails: (json['repay_loan_details'] as List?)
          ?.map((item) => RepayLoanDetail.fromJson(item))
          .toList(),
    );
  }
}