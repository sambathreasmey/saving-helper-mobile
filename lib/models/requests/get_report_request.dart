class GetReportRequest {
  String? channelId;
  String? userId;
  String? groupId;
  String? reportType;
  int? pageNum;
  int? pageSize;

  GetReportRequest(
      {this.channelId,
        this.userId,
        this.groupId,
        this.reportType,
        this.pageNum,
        this.pageSize});

  GetReportRequest.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    userId = json['user_id'];
    groupId = json['group_id'];
    reportType = json['report_type'];
    pageNum = json['page_num'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['user_id'] = this.userId;
    data['group_id'] = this.groupId;
    data['report_type'] = this.reportType;
    data['page_num'] = this.pageNum;
    data['page_size'] = this.pageSize;
    return data;
  }
}