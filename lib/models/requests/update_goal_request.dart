class UpdateGoalRequest {
  String? userId;
  String? groupId;
  String? goalName;
  double? goalAmount;

  UpdateGoalRequest(
      {this.userId,
        this.groupId,
        this.goalName,
        this.goalAmount});

  UpdateGoalRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    groupId = json['group_id'];
    goalName = json['group_name'];
    goalAmount = json['goal_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['group_id'] = groupId;
    data['group_name'] = goalName;
    data['goal_amount'] = goalAmount;
    return data;
  }
}