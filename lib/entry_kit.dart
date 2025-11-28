/// EntryKit is a production-ready, unopinionated authentication UI package.
///
/// It decouples the UI (Presentation Layer) from the Backend (Logic Layer) via
/// the [AuthRepository] contract. This allows you to use any backend (Firebase,
/// Supabase, REST) with the same pre-built widgets.
library entry_kit;

export 'src/contract/auth_repository.dart';
export 'src/config/login_theme.dart';
export 'src/config/login_texts.dart';
export 'src/config/password_config.dart';
export 'src/presentation/login_view.dart';
export 'src/presentation/signup_view.dart';
export 'src/presentation/forgot_password_view.dart';