import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/layouts/auth_form_scaffold.dart';
import '../../../shared/layouts/auth_layout.dart';
import '../../../shared/widgets/novora_logo.dart';
import '../auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _showConfirmPass = false;
  bool _loading = false;
  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _loginRecognizer = TapGestureRecognizer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginRecognizer.onTap = () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    };
  }

  @override
  void dispose() {
    _loginRecognizer.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (_passCtrl.text != _confirmCtrl.text) {
      AppSnackBar.showError(context, 'Passwords do not match.');
      return;
    }
    final pwdErr = strongPasswordValidator(_passCtrl.text);
    if (pwdErr != null) {
      AppSnackBar.showError(context, pwdErr);
      return;
    }
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) {
      AppSnackBar.showError(context, 'Please complete email and password.');
      return;
    }
    setState(() => _loading = true);
    try {
      await _auth.register(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Registration failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      form: AuthFormScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NovoraLogo(width: 220),
            const SizedBox(height: 24),
            Text(
              'Create Account',
              style: GoogleFonts.sora(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                height: 1.15,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in your details to get started.',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            AuthTextField(
              label: 'Full Name',
              hint: 'John Doe',
              controller: _nameCtrl,
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Work Email',
              hint: 'name@novora.com',
              controller: _emailCtrl,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passCtrl,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !_showPass,
              suffix: IconButton(
                icon: Icon(
                  _showPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
                onPressed: () => setState(() => _showPass = !_showPass),
              ),
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Confirm Password',
              hint: 'Confirm your password',
              controller: _confirmCtrl,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !_showConfirmPass,
              suffix: IconButton(
                icon: Icon(
                  _showConfirmPass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _showConfirmPass = !_showConfirmPass),
              ),
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              label: 'Create Account',
              isLoading: _loading,
              onPressed: _loading ? null : _submit,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      recognizer: _loginRecognizer,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
