class DashboardModel {
  String? balance;
  String? loanBalance;
  String? savingThisMonth;
  String? savingToday;
  String? savingYesterday;
  String? totalLoan;
  String? totalLoanRepay;
  String? totalSavingDeposit;
  String? target;

  DashboardModel({
    this.balance,
    this.loanBalance,
    this.savingThisMonth,
    this.savingToday,
    this.savingYesterday,
    this.totalLoan,
    this.totalLoanRepay,
    this.totalSavingDeposit,
    this.target,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      balance: json['balance'],
      loanBalance: json['loan_balance'],
      savingThisMonth: json['saving_this_month'],
      savingToday: json['saving_today'],
      savingYesterday: json['saving_yesterday'],
      totalLoan: json['total_loan'],
      totalLoanRepay: json['total_loan_repay'],
      totalSavingDeposit: json['total_saving_deposit'],
      target: json['target'],
    );
  }
}