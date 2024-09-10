import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

@module 
abstract class FirebaseAuthModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}