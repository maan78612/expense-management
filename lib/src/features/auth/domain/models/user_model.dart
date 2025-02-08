import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_managment/src/core/enums/user_status.dart';

class UserModel {
  String name;
  String email;

  double remainingMonthlyLimit;
  String currentMonth;
  double availableBalance;
  DateTime createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.remainingMonthlyLimit,
    required this.currentMonth,
    required this.availableBalance,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(dynamic json) => UserModel(
        name: json["name"],
        email: json["email"],
        remainingMonthlyLimit:
            double.parse(json["remainingMonthlyLimit"].toString()),
        currentMonth: json["currentMonth"],
        availableBalance: double.parse(json["availableBalance"].toString()),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  // Helper method to map a string to the UserStatus enum
  static UserStatus _mapStringToUserStatus(String status) {
    switch (status) {
      case 'not_verified':
        return UserStatus.notVerified;
      case 'verified':
        return UserStatus.verified;
      default:
        throw Exception('Unknown UserStatus: $status');
    }
  }

  // Method to convert a UserModel instance to JSON
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "remainingMonthlyLimit": remainingMonthlyLimit,
        "currentMonth": currentMonth,
        "availableBalance": availableBalance,
        "createdAt": createdAt.toIso8601String(),
      };

  // copyWith method to create a new instance with modified fields
  UserModel copyWith({
    String? name,
    String? id,
    String? email,
    UserStatus? status,
    double? remainingMonthlyLimit,
    String? currentMonth,
    double? availableBalance,
    DateTime? createdAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      remainingMonthlyLimit:
          remainingMonthlyLimit ?? this.remainingMonthlyLimit,
      currentMonth: currentMonth ?? this.currentMonth,
      availableBalance: availableBalance ?? this.availableBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      name: '',

      email: '',

      // Default status
      remainingMonthlyLimit: 0.0,
      currentMonth: '',
      availableBalance: 0.0,
      createdAt: DateTime.now(), // Default to current date
    );
  }
}

class UserModelProvider extends StateNotifier<UserModel> {
  UserModelProvider() : super(UserModel.empty());

  void setUser(UserModel newUser) {
    state = newUser;
  }

  void updateBalance(double amount) {
    /// update user model with new available balance
    state = state.copyWith(availableBalance: state.availableBalance - amount);
  }

  void updateMonthlyLimit(double amount) {
    /// update user model with new limit
    state = state.copyWith(
        remainingMonthlyLimit: state.remainingMonthlyLimit - amount);
  }
}
