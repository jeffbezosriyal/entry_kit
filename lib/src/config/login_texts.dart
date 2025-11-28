class LoginTexts {
  final String emailLabel;
  final String passwordLabel;
  final String confirmPasswordLabel; // <--- NEW
  final String loginButton;
  final String createAccountButton; // <--- NEW
  final String forgotPassword;
  final String noAccount;
  final String alreadyHaveAccount; // <--- NEW
  final String signUp;
  final String signIn; // <--- NEW
  final String emailError;
  final String passwordError;
  final String passwordMatchError; // <--- NEW
  final String googleButton;
  final String appleButton; // <--- NEW
  final String orSeparator;
  final String forgotPasswordTitle;
  final String sendResetLinkButton;
  final String backToLogin;
  final String resetLinkSentMessage;

  const LoginTexts({
    this.emailLabel = 'Email',
    this.passwordLabel = 'Password',
    this.confirmPasswordLabel = 'Confirm Password',
    this.loginButton = 'Login',
    this.createAccountButton = 'Create Account',
    this.forgotPassword = 'Forgot Password?',

    // Defaults for new fields
    this.forgotPasswordTitle = 'Reset Password',
    this.sendResetLinkButton = 'Send Reset Link',
    this.backToLogin = 'Back to Login',
    this.resetLinkSentMessage = 'Reset link sent! Check your email.',
    this.noAccount = "Don't have an account? ",
    this.alreadyHaveAccount = 'Already have an account? ',
    this.signUp = 'Sign Up',
    this.signIn = 'Sign In',
    this.emailError = 'Enter a valid email address',
    this.passwordError = 'Password must be at least 6 characters',
    this.passwordMatchError = 'Passwords do not match',
    this.googleButton = 'Sign in with Google',
    this.appleButton = 'Sign in with Apple',
    this.orSeparator = 'OR',
  });
}
