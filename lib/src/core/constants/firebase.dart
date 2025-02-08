import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FBCollections {
  static CollectionReference users = db.collection("users");
  static CollectionReference notifications = db.collection("notifications");

}
