import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModel {
  String name;
  String email;
  DateTime createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(dynamic json) => UserModel(
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  // Method to convert a UserModel instance to JSON
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
      };

  // copyWith method to create a new instance with modified fields
  UserModel copyWith({
    String? name,
    String? email,
    double? availableBalance,
    DateTime? createdAt,
    String? fcm,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      name: '',
      email: '',

      createdAt: DateTime.now(), // Default to current date
    );
  }
}

class UserModelProvider extends StateNotifier<UserModel> {
  UserModelProvider() : super(UserModel.empty());

  void setUser(UserModel newUser) {
    state = newUser;
  }

  void updateFcm(String fcm) {
    /// update user model with new available balance
    state = state.copyWith(fcm: fcm);
  }
}
