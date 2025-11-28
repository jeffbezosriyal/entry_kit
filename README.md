# 🚪 EntryKit

EntryKit is a production-ready, backend-agnostic authentication UI package for Flutter.

It creates a strict separation between UI (Presentation) and Logic (Authentication), allowing you to swap backends (Firebase, Supabase, AWS, REST API) without touching a single pixel of your login screens.

---

## ✨ Features

- **📱 Pre-built Screens:** Login, Sign Up, and Forgot Password flows ready out-of-the-box.
- **🧠 State Management:** Powered internally by `flutter_bloc` for robust state transitions.
- **🔐 Social Authentication:** First-class support for Google and Apple Sign In.
- **🎨 Theming Engine:** Fully customizable colors, fonts, shapes, and inputs.
- **🛡️ Security Rules:** Configurable password complexity (length, special chars, uppercase).
- **🌍 Internationalization:** Every text string is replaceable via configuration.
- **✅ 100% Tested:** Core logic and critical UI paths are fully verified.

---

## 📦 Installation

Add the package from GitHub:

```yaml
dependencies:
  entry_kit:
    git:
      url: https://github.com/jeffbezosriyal/entry_kit.git
      ref: main

🏗️ Architecture
EntryKit uses the Contract Pattern.

Contract: You implement the AuthRepository interface.

Injection: You pass your implementation to the LoginView.

Result: EntryKit handles loading states, error parsing, and UI updates automatically.

🚀 Getting Started
1. Implement the Repository
dart
Copy code
import 'package:entry_kit/entry_kit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyBackendRepository implements AuthRepository {
  @override
  Future<void> signIn({required String email, required String password}) async {
    // Example: Firebase auth login
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    // Example: Firebase auth signup
  }

  @override
  Future<void> resetPassword({required String email}) async {
    // Example: Firebase reset password
  }

  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return null;
  }

  @override
  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    return null;
  }
}
2. Render the Views
dart
Copy code
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(
        authRepository: MyBackendRepository(),
        logo: Image.asset('assets/logo.png', height: 100),

        enableGoogleAuth: true,
        enableAppleAuth: true,

        onLoginSuccess: () => print("Navigate to Home"),
        onForgotPassword: () => print("Navigate to Forgot Password"),
        onSignUp: () => print("Navigate to Sign Up"),
      ),
    );
  }
}
🎨 Customization
Visual Theme
dart
Copy code
LoginView(
  theme: LoginTheme(
    primaryColor: Colors.deepPurple,
    backgroundColor: Colors.white,
    inputFillColor: Colors.grey[200],
    inputBorderRadius: 16.0,
    inputTextStyle: TextStyle(color: Colors.black87),
    titleStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
)
Text & Labels (i18n)
dart
Copy code
LoginView(
  texts: LoginTexts(
    loginButton: "Start Adventure",
    emailLabel: "Username / Email",
    forgotPassword: "Lost your key?",
    googleButton: "Continue via Google",
  ),
)
Password Security
dart
Copy code
SignUpView(
  passwordConfig: PasswordConfig(
    minLength: 8,
    requireUppercase: true,
    requireDigit: true,
    requireSpecialChar: true,
  ),
)
📂 Project Structure
bash
Copy code
entry_kit/
├── lib/
│   ├── src/
│   │   ├── config/       # Themes, Texts, Password Rules
│   │   ├── contract/     # AuthRepository Interface
│   │   ├── logic/        # Cubits & Validators (Bloc)
│   │   └── presentation/ # UI Widgets (Login, SignUp, etc)
│   └── entry_kit.dart    # Public API exports
├── test/                 # 100% Coverage Unit & Widget Tests
└── pubspec.yaml
🤝 Contributing
Fork the project
git commit -m "Add AmazingFeature"
Push the branch

perl
Copy code
git push origin feature/AmazingFeature
