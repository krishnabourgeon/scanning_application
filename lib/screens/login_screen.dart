import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import '../services/validation_helper.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  void _submit(AuthProvider auth) {
    if (!auth.isLoginFormValidated) return;
    auth.login(
      onSuccess: () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      },
      onFailure: () {
        if (auth.errorToast != null) Helpers.errorToast(auth.errorToast!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.loaderState == LoaderState.loading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Volunteer Check-in',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to manage event attendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: auth.loginNameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => auth.updateValidationMessages(
                    validationType: ValidationTypes.userName,
                    validationMessage:
                        ValidationHelperClass.validateName(v) ?? '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline,
                        color: AppColors.brown),
                    errorText: auth.userNameValidationMessage,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: auth.loginPasswordController,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => auth.updateValidationMessages(
                    validationType: ValidationTypes.password,
                    validationMessage:
                        ValidationHelperClass.validatePassword(v) ?? '',
                  ),
                  onSubmitted: (_) => _submit(auth),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: AppColors.brown),
                    errorText: auth.passwordValidationMessage,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.muted,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: auth.isRememberCredentials,
                      activeColor: AppColors.brown,
                      onChanged: (v) =>
                          auth.updateRememberMeValue(v ?? false),
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (isLoading || !auth.isLoginFormValidated)
                      ? null
                      : () => _submit(auth),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
