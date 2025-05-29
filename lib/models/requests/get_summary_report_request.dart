class GetSummaryReportRequest {
  String? channelId;
  String? groupId;
  int? pageNum;
  int? pageSize;

  GetSummaryReportRequest(
      {this.channelId,
        this.groupId,
        this.pageNum,
        this.pageSize});

  GetSummaryReportRequest.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    groupId = json['group_id'];
    pageNum = json['page_num'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['group_id'] = this.groupId;
    data['page_num'] = this.pageNum;
    data['page_size'] = this.pageSize;
    return data;
  }
}