import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkang_admin/models/user_model.dart';
import 'package:parkang_admin/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user model object based on FirebaseUser
  UserModel? _userFromFirebaseUser(User user) {
    return UserModel(uid: user.uid);
  }

  // auth change user stream
  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print(e.code);
      return _handleAuthErrorCodes(e.code);
    }
  }

  Future<dynamic> registerWithEmailAndPassword(
      {required String name,
      required String email,
      required String password,
      required String role}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await user.updateDisplayName(name);
      await DatabaseService().createDefaultUser(user.uid, role, user, name);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print(e.code);
      return _handleAuthErrorCodes(e.code);
    }
  }

  String _handleAuthErrorCodes(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
