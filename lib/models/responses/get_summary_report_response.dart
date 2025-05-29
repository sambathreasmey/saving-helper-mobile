class GetSummaryReportResponse {
  int? code;
  List<Data>? data;
  String? message;
  int? status;

  GetSummaryReportResponse({this.code, this.data, this.message, this.status});

  GetSummaryReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? currencyType;
  String? month;
  double? totalAmount;

  Data({this.currencyType, this.month, this.totalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    currencyType = json['currency_type'];
    month = json['month'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_type'] = this.currencyType;
    data['month'] = this.month;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}