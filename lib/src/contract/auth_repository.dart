import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// The abstract contract that defines how authentication is handled.
///
/// You must implement this class in your application to connect [EntryKit]
/// to your actual backend (e.g., Firebase, REST API).
abstract class AuthRepository {
  /// Signs in a user with the given [email] and [password].
  ///
  /// Should throw an [Exception] if the login fails (e.g., wrong password).
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Registers a new user with the given [email] and [password].
  ///
  /// Should throw an [Exception] if registration fails (e.g., email exists).
  Future<void> signUp({
    required String email,
    required String password,
  });

  /// Sends a password reset email to the given [email].
  Future<void> resetPassword({
    required String email,
  });

  /// Triggers the Google Sign-In flow.
  ///
  /// Returns the [GoogleSignInAccount] if successful, or `null` if cancelled.
  Future<GoogleSignInAccount?> signInWithGoogle();

  /// Triggers the Sign In with Apple flow.
  ///
  /// Returns the [AuthorizationCredentialAppleID] if successful.
  Future<AuthorizationCredentialAppleID?> signInWithApple();
}