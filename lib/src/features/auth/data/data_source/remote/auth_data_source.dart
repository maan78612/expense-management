import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_managment/src/core/constants/firebase.dart';
import 'package:expense_managment/src/core/enums/notification_type.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/notifications/domain/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check internet connection
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Email & Password Registration
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (!(await isConnected())) throw "No internet connection";

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get FCM token
      final fcmToken = await _getFcmToken();

      // Create user profile
      final userProfile = UserModel(
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      await FBCollections.users
          .doc(userCredential.user!.email)
          .set(userProfile.toJson());

      await _creationNotification(userProfile);

      return userProfile;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint("Registration error: $e");
      rethrow;
    }
  }

  Future<void> _creationNotification(UserModel userProfile) async {
    final notification = NotificationModel(
      createdAt: DateTime.now(),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Profile Created Successfully',
      message: 'Your profile has been created successfully',
      type: NotificationType.success,
      sendTo: [userProfile.email],
    );
    await FBCollections.notifications
        .doc(notification.id)
        .set(notification.toJson());
  }

  Future<UserModel?> autoLogin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await FBCollections.users.doc(user.email).get();
      if (!doc.exists) return null;

      // Update FCM token
      final fcmToken = await _getFcmToken();
      await _updateFcmToken(user.uid, fcmToken);

      return UserModel.fromJson(doc.data()!).copyWith(fcm: fcmToken);
    } catch (e) {
      debugPrint("Auto login error: $e");
      return null;
    }
  }

  // Email & Password Login
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!(await isConnected())) throw "No internet connection";

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user document
      final doc =
          await FBCollections.users.doc(userCredential.user!.email).get();

      if (!doc.exists) throw "User profile not found";

      final userProfile = UserModel.fromJson(doc.data()!);

      // Update FCM token
      final fcmToken = await _getFcmToken();
      await _updateFcmToken(userCredential.user!.email!, fcmToken);

      return userProfile.copyWith(fcm: fcmToken);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint("Login error: $e");
      rethrow;
    }
  }

  // Get FCM Token
  Future<String> _getFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      return token ?? '';
    } catch (e) {
      debugPrint("FCM token error: $e");
      return '';
    }
  }

  Future<void> _updateFcmToken(String email, String fcmToken) async {
    try {
      await FBCollections.users.doc(email).update({
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Update FCM error: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Sign out error: $e");
      rethrow;
    }
  }

  // Error handling
  String _handleAuthError(FirebaseAuthException e) {
    debugPrint(e.code.toString());
    switch (e.code) {
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'user-disabled':
        return 'Account disabled';
      case 'user-not-found':
        return 'Account not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
