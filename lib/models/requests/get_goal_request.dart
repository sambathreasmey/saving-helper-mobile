class GetGoalRequest {
  String? userId;
  int? pageNum;
  int? pageSize;

  GetGoalRequest(
      {this.userId,
        this.pageNum,
        this.pageSize});

  GetGoalRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    pageNum = json['page_num'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['page_num'] = this.pageNum;
    data['page_size'] = this.pageSize;
    return data;
  }
}