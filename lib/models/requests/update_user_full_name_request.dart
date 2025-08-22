class UpdateUserFullNameRequest {
  final String userId;
  final String fullName;

  UpdateUserFullNameRequest({
    required this.userId,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'full_name': fullName,
  };
}
