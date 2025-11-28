import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../contract/auth_repository.dart';
import '../config/login_theme.dart';
import '../config/login_texts.dart';
import '../logic/forgot_password_cubit.dart';
import '../logic/forgot_password_state.dart';
import '../logic/input_validators.dart';

class ForgotPasswordView extends StatelessWidget {
  final AuthRepository authRepository;
  final LoginTheme? theme;
  final LoginTexts? texts;
  final Widget? logo;
  final VoidCallback? onBackToLogin;

  const ForgotPasswordView({
    Key? key,
    required this.authRepository,
    this.theme,
    this.texts,
    this.logo,
    this.onBackToLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(authRepository),
      child: Scaffold(
        backgroundColor: theme?.backgroundColor ?? Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme?.primaryColor ?? Colors.black),
            onPressed: onBackToLogin,
          ),
        ),
        body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state.status == ForgotPasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? "Failed to send link"),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.status == ForgotPasswordStatus.success) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(texts?.resetLinkSentMessage ?? "Reset link sent!"),
                  backgroundColor: Colors.green,
                ),
              );
              // Optional: You could auto-navigate back here if desired
            }
          },
          builder: (context, state) {
            if (state.status == ForgotPasswordStatus.submitting) {
              return Center(
                child: CircularProgressIndicator(color: theme?.primaryColor),
              );
            }
            return _ForgotPasswordForm(
              theme: theme,
              texts: texts ?? const LoginTexts(),
              logo: logo,
            );
          },
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  final LoginTheme? theme;
  final LoginTexts texts;
  final Widget? logo;

  const _ForgotPasswordForm({
    Key? key,
    this.theme,
    required this.texts,
    this.logo,
  }) : super(key: key);

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<ForgotPasswordCubit>().submitResetRequest(
        _emailController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              if (widget.logo != null) ...[
                widget.logo!,
                const SizedBox(height: 32),
              ],

              Text(
                widget.texts.forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: widget.theme?.titleStyle ??
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              // Email Field
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

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme?.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        widget.theme?.inputBorderRadius ?? 8.0),
                  ),
                ),
                child: Text(
                  widget.texts.sendResetLinkButton,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}