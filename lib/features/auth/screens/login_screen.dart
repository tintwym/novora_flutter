import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/error/exceptions.dart';
import '../../../shared/layouts/auth_form_scaffold.dart';
import '../../../shared/layouts/auth_layout.dart';
import '../../../shared/widgets/auth_form_header.dart';
import '../auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _loading = false;
  bool _rememberMe = false;
  late final TapGestureRecognizer _registerRecognizer;

  @override
  void initState() {
    super.initState();
    _registerRecognizer = TapGestureRecognizer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerRecognizer.onTap = () =>
        Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  void dispose() {
    _registerRecognizer.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      AppSnackBar.showError(context, 'Enter email and password.');
      return;
    }
    setState(() => _loading = true);
    try {
      await _auth.login(email, pass);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Sign in failed: $e');
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
            const AuthFormHeader(),
            Text(
              'Sign in',
              style: GoogleFonts.sora(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
                height: 1.15,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back! Please sign in to your account.',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            AuthTextField(
              label: 'Work Email',
              hint: 'name@novora.com',
              controller: _emailCtrl,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
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
            const SizedBox(height: 18),
            Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: _rememberMe,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primary;
                      }
                      return Colors.white;
                    }),
                    checkColor: Colors.white,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Remember me',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            AuthPrimaryButton(
              label: 'Sign In',
              isLoading: _loading,
              onPressed: _loading ? null : _submit,
            ),
            const SizedBox(height: 22),
            _OrDivider(),
            const SizedBox(height: 20),
            Center(
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Register',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      recognizer: _registerRecognizer,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Secure login powered by ${AppStrings.appTitle}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final line = Expanded(child: Container(height: 1, color: AppColors.border));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
