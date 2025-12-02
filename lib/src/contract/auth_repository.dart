import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// The abstract interface that connects the UI to your authentication backend.
///
/// You must implement this class in your application to define *how*
/// users actually log in, register, or reset passwords.
abstract class AuthRepository {
  /// Signs in a user with an [email] and [password].
  ///
  /// Should throw an [Exception] if the credentials are invalid.
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Registers a new user with an [email] and [password].
  ///
  /// Should throw an [Exception] if the email is already in use.
  Future<void> signUp({
    required String email,
    required String password,
  });

  /// Sends a password reset link to the specified [email].
  Future<void> resetPassword({
    required String email,
  });

  /// Triggers the native Google Sign-In authentication flow.
  ///
  /// Returns the [GoogleSignInAccount] if successful, or `null` if the user cancels.
  Future<GoogleSignInAccount?> signInWithGoogle();

  /// Triggers the native Sign in with Apple authentication flow.
  ///
  /// Returns the [AuthorizationCredentialAppleID] if successful.
  Future<AuthorizationCredentialAppleID?> signInWithApple();
}
