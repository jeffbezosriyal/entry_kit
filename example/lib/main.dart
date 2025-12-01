import 'package:flutter/material.dart';
import 'package:entry_kit/entry_kit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  runApp(const EntryKitExampleApp());
}

class EntryKitExampleApp extends StatelessWidget {
  const EntryKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EntryKit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const AuthCoordinator(),
    );
  }
}

/// A "Coordinator" widget to handle navigation between the different auth screens.
class AuthCoordinator extends StatefulWidget {
  const AuthCoordinator({super.key});

  @override
  State<AuthCoordinator> createState() => _AuthCoordinatorState();
}

class _AuthCoordinatorState extends State<AuthCoordinator> {
  // Simple state to toggle screens for the demo
  String _currentView = 'login'; // Options: login, signup, forgot_password, home

  final MockAuthRepository _repository = MockAuthRepository();

  @override
  Widget build(BuildContext context) {
    // 1. If user is "logged in", show the Home Screen
    if (_currentView == 'home') {
      return Scaffold(
        appBar: AppBar(title: const Text("Dashboard")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome! You are logged in."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => _currentView = 'login'),
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Define a common Theme for the auth screens
    const authTheme = LoginTheme(
      primaryColor: Colors.indigo,
      backgroundColor: Colors.white,
      inputBorderRadius: 12.0,
      titleStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.indigo,
      ),
    );

    // 3. Show the correct screen based on state
    switch (_currentView) {
      case 'signup':
        return SignUpView(
          authRepository: _repository,
          theme: authTheme,
          enableGoogleAuth: true,
          logo: const _DemoLogo(),
          onLoginTap: () => setState(() => _currentView = 'login'),
          onSignUpSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account Created! Logging in...")),
            );
            setState(() => _currentView = 'home');
          },
        );

      case 'forgot_password':
        return ForgotPasswordView(
          authRepository: _repository,
          theme: authTheme,
          logo: const _DemoLogo(),
          onBackToLogin: () => setState(() => _currentView = 'login'),
        );

      case 'login':
      default:
        return LoginView(
          authRepository: _repository,
          theme: authTheme,
          enableGoogleAuth: true,
          enableAppleAuth: false, // Hidden for this demo
          logo: const _DemoLogo(),
          onSignUp: () => setState(() => _currentView = 'signup'),
          onForgotPassword: () => setState(() => _currentView = 'forgot_password'),
          onLoginSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successful!")),
            );
            setState(() => _currentView = 'home');
          },
        );
    }
  }
}

/// A simple placeholder logo
class _DemoLogo extends StatelessWidget {
  const _DemoLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.lock_person_rounded, size: 40, color: Colors.indigo),
    );
  }
}

/// MOCK REPOSITORY implementation
/// This simulates a backend delay.
class MockAuthRepository implements AuthRepository {
  @override
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains("error")) {
      throw Exception("User not found (Mock Error)");
    }
    // Success
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains("taken")) {
      throw Exception("Email already in use (Mock Error)");
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    // Note: In a real app, you would return the account object.
    // For this mock/UI test, returning null works because the
    // Cubit in this specific version doesn't check the return value,
    // it only checks for Exceptions.
    return null;
  }

  @override
  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }
}