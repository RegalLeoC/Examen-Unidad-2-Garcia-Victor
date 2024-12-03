class Access {
  final String username;
  final String email;
  final String accessToken;

  Access({
    required this.username,
    required this.email,
    required this.accessToken,
  });

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }
}
