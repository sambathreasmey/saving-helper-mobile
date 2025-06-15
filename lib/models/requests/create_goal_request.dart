class CreateGoalRequest {
  String? userId;
  String? goalName;
  double? goalAmount;

  CreateGoalRequest(
      {this.userId,
        this.goalName,
        this.goalAmount});

  CreateGoalRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    goalName = json['goal_name'];
    goalAmount = json['goal_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['goal_name'] = goalName;
    data['goal_amount'] = goalAmount;
    return data;
  }
}