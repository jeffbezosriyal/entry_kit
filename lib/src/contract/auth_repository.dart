import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // <--- THIS WAS MISSING

abstract class AuthRepository {
  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> resetPassword({required String email});

  /// Returns the Google User object
  Future<GoogleSignInAccount?> signInWithGoogle();

  /// Returns the Apple Credential object
  Future<AuthorizationCredentialAppleID?> signInWithApple();
}
