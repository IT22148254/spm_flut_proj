import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';

abstract class AuthService {
  Future<User?> signIn(String email, String password);
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<void> signOut();
}

@LazySingleton(as: AuthService)
class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger;

  FirebaseAuthService(this._firebaseAuth, this._logger);

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing in with email and password: $e');
      rethrow;
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      _logger.e('error sign in with google$e');
      rethrow;
    }
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        return null;
      }
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      _logger.e('Error signing in with Facebook: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _logger.e('Error signing out: $e');
      rethrow;
    }
  }
}
