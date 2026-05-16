import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/auth/user_roles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/session/session_notifier.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _refreshing = false;

  Future<bool?> _showLogoutConfirmDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Log out?',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          content: Text(
            'You will be signed out of Novora. You can sign in again at any time.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              height: 1.45,
              color: scheme.onSurfaceVariant,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Log out',
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await AuthRepository().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _onLogoutPressed() async {
    final ok = await _showLogoutConfirmDialog();
    if (ok == true && mounted) {
      await _logout();
    }
  }

  Future<void> _refreshAccount() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    final user = await AuthRepository().refreshProfile();
    if (!mounted) return;
    setState(() => _refreshing = false);
    if (user == null) {
      AppSnackBar.showError(
        context,
        'Could not refresh account. Log out and sign in again.',
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Role updated: ${UserRoles.label(user.primaryRole)}. Go to Dashboard.',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SessionNotifier.instance,
      builder: (context, _) {
        final user = SessionNotifier.instance.user;
        final email = user?.email ?? '';
        final role = UserRoles.label(user?.primaryRole);
        return _buildBody(context, email, role);
      },
    );
  }

  Widget _buildBody(BuildContext context, String email, String role) {
    final scheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Account',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(context, 'Email', email.isEmpty ? '—' : email),
                    const SizedBox(height: 10),
                    _row(context, 'Role', role),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Changed your role in the database? Refresh here, or log out and sign in again.',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _refreshing ? null : _refreshAccount,
                icon: _refreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  'Refresh account',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _onLogoutPressed,
                icon: Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
                label: Text(
                  'Log out',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.embeddedInShell) {
      return ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
      ),
      body: body,
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
