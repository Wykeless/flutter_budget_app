class Password {
  final String password;
  final String email;
  final String salt;

  Password({
    required this.password,
    required this.email,
    required this.salt,
  });

  Password copyWith({
    String? password,
    String? email,
    String? salt,
  }) {
    return Password(
      password: password ?? this.password,
      email: email ?? this.email,
      salt: salt ?? this.salt,
    );
  }
}
