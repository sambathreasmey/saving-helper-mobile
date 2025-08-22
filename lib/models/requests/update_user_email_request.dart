class UpdateUserEmailRequest {
  final String userId;
  final String email;

  UpdateUserEmailRequest({
    required this.userId,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'email': email,
  };
}
