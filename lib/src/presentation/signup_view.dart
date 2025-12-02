import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../contract/auth_repository.dart';
import '../config/login_theme.dart';
import '../config/login_texts.dart';
import '../config/password_config.dart';
import '../logic/signup_cubit.dart';
import '../logic/signup_state.dart';
import '../logic/input_validators.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpView extends StatelessWidget {
  final AuthRepository authRepository;
  final LoginTheme? theme;
  final LoginTexts? texts;
  final PasswordConfig? passwordConfig;
  final Widget? logo;
  final bool enableGoogleAuth;
  final bool enableAppleAuth; // <--- NEW
  final VoidCallback? onSignUpSuccess;
  final VoidCallback? onLoginTap;

  const SignUpView({
    super.key,
    required this.authRepository,
    this.theme,
    this.texts,
    this.passwordConfig,
    this.logo,
    this.enableGoogleAuth = false,
    this.enableAppleAuth = false,
    this.onSignUpSuccess,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(authRepository),
      child: Scaffold(
        backgroundColor: theme?.backgroundColor ?? Colors.white,
        body: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? "Registration Failed"),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.status == SignUpStatus.success) {
              onSignUpSuccess?.call();
            }
          },
          builder: (context, state) {
            if (state.status == SignUpStatus.submitting) {
              return Center(
                child: CircularProgressIndicator(color: theme?.primaryColor),
              );
            }
            return _SignUpForm(
              theme: theme,
              texts: texts ?? const LoginTexts(),
              passwordConfig: passwordConfig ?? const PasswordConfig(),
              logo: logo,
              enableGoogleAuth: enableGoogleAuth,
              enableAppleAuth: enableAppleAuth,
              onLoginTap: onLoginTap,
            );
          },
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  final LoginTheme? theme;
  final LoginTexts texts;
  final PasswordConfig passwordConfig;
  final Widget? logo;
  final bool enableGoogleAuth;
  final bool enableAppleAuth;
  final VoidCallback? onLoginTap;

  const _SignUpForm({
    super.key,
    this.theme,
    required this.texts,
    required this.passwordConfig,
    this.logo,
    required this.enableGoogleAuth,
    required this.enableAppleAuth,
    this.onLoginTap,
  });

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<SignUpCubit>().signupSubmitted(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  void _onGooglePressed() {
    FocusScope.of(context).unfocus();
    context.read<SignUpCubit>().googleSignupSubmitted();
  }

  void _onApplePressed() {
    FocusScope.of(context).unfocus();
    context.read<SignUpCubit>().appleSignupSubmitted();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo
              if (widget.logo != null) ...[
                widget.logo!,
                const SizedBox(height: 32),
              ],

              // 2. Email
              TextFormField(
                controller: _emailController,
                validator: (val) => InputValidators.validateEmail(val) != null
                    ? widget.texts.emailError
                    : null,
                keyboardType: TextInputType.emailAddress,
                style: widget.theme?.inputTextStyle,
                decoration: InputDecoration(
                  labelText: widget.texts.emailLabel,
                  labelStyle: widget.theme?.inputTextStyle,
                  fillColor: widget.theme?.inputFillColor,
                  filled: widget.theme?.inputFillColor != null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        widget.theme?.inputBorderRadius ?? 8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Password
              TextFormField(
                controller: _passwordController,
                validator: (val) => InputValidators.validatePassword(
                    val, widget.passwordConfig),
                obscureText: true,
                style: widget.theme?.inputTextStyle,
                decoration: InputDecoration(
                  labelText: widget.texts.passwordLabel,
                  labelStyle: widget.theme?.inputTextStyle,
                  fillColor: widget.theme?.inputFillColor,
                  filled: widget.theme?.inputFillColor != null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        widget.theme?.inputBorderRadius ?? 8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: widget.theme?.inputTextStyle,
                validator: (val) {
                  if (val != _passwordController.text) {
                    return widget.texts.passwordMatchError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: widget.texts.confirmPasswordLabel,
                  labelStyle: widget.theme?.inputTextStyle,
                  fillColor: widget.theme?.inputFillColor,
                  filled: widget.theme?.inputFillColor != null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        widget.theme?.inputBorderRadius ?? 8.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Create Account Button
              ElevatedButton(
                onPressed: _onSignUpPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme?.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        widget.theme?.inputBorderRadius ?? 8.0),
                  ),
                ),
                child: Text(
                  widget.texts.createAccountButton,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              // 6. Social Authentication Section
              if (widget.enableGoogleAuth || widget.enableAppleAuth) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.texts.orSeparator,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Google Button
              if (widget.enableGoogleAuth) ...[
                OutlinedButton.icon(
                  onPressed: _onGooglePressed,
                  icon: SvgPicture.asset(
                    'assets/google_logo.svg',
                    package: 'entry_kit', // <--- Crucial!
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    widget.texts.googleButton,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          widget.theme?.inputBorderRadius ?? 8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Apple Button
              if (widget.enableAppleAuth) ...[
                ElevatedButton.icon(
                  onPressed: _onApplePressed,
                  icon: const Icon(Icons.apple, color: Colors.white, size: 22),
                  label: Text(
                    widget.texts.appleButton,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black, // Standard Apple Black
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          widget.theme?.inputBorderRadius ?? 8.0),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // 7. Login Link
              if (widget.onLoginTap != null)
                TextButton(
                  onPressed: widget.onLoginTap,
                  child: RichText(
                    text: TextSpan(
                      text: widget.texts.alreadyHaveAccount,
                      style: const TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: widget.texts.signIn,
                          style: TextStyle(
                            color: widget.theme?.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
