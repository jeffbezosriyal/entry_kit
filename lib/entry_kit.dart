/// EntryKit is a production-ready authentication UI package for Flutter.
///
/// It provides pre-built [LoginView], [SignUpView], and [ForgotPasswordView] screens
/// that are backend-agnostic. You simply implement the [AuthRepository] interface
/// to connect it to Firebase, Supabase, or any custom API.
library entry_kit;

export 'src/contract/auth_repository.dart';
export 'src/config/login_theme.dart';
export 'src/config/login_texts.dart';
export 'src/config/password_config.dart';
export 'src/presentation/login_view.dart';
export 'src/presentation/signup_view.dart';
export 'src/presentation/forgot_password_view.dart';