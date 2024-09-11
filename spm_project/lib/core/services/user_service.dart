import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_project/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spm_project/di/injectable.dart';
import 'package:logger/logger.dart';

class UserService {
  FirebaseAuth firebaseAuth = getit<FirebaseAuth>();
  FirebaseFirestore firestore = getit<FirebaseFirestore>();
  final Logger _logger = getit<Logger>();

  Future<void> addUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        UserModel us = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
        await firestore.collection("Users").doc(us.id).set(us.toJson());
      } else {
        _logger.e("No user is currently logged in.");
      }
    } catch (e) {
      _logger.e("Error adding user: $e");
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      var usersSnapShot = await firestore.collection("Users").get();
      List<UserModel> users = usersSnapShot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();

      return users;
    } catch (e) {
      _logger.e("Error getting users from firestore: $e");
      return [];
    }
  }
}
