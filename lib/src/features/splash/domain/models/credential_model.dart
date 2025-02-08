class CredentialsModel {
  final String email;
  final String password;

  CredentialsModel({
    required this.email,
    required this.password,
  });

  // Factory method to create a CredentialsModel from JSON
  factory CredentialsModel.fromJson(Map<String, dynamic> json) {
    return CredentialsModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Method to convert the CredentialsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
