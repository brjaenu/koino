import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthenticationService(this._firebaseAuth);

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Future<String>.value("Signed In");
    } on FirebaseAuthException catch (e) {
      return Future<String>.error(e.message);
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Future<String>.value("Signed Up");
    } on FirebaseAuthException catch (e) {
      return Future<String>.error(e.message);
    }
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
