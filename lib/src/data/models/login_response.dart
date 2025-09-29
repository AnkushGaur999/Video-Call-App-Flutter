class LoginResponse {
  final bool success;
  final String message;
  final bool error;

  LoginResponse({
    required this.success,
    required this.message,
    required this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'error': error};
  }
}
