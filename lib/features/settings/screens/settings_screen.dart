import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/auth/user_roles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/session/session_notifier.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../models/settings_nav_item.dart';
import '../panels/settings_panels.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedId = 'company_profile';
  String _search = '';
  bool _refreshing = false;

  Iterable<SettingsNavSection> get _filteredSections {
    if (_search.trim().isEmpty) return SettingsNav.sections;
    final q = _search.toLowerCase();
    return SettingsNav.sections
        .map(
          (s) => SettingsNavSection(
            title: s.title,
            items: s.items.where((i) => i.label.toLowerCase().contains(q)).toList(),
          ),
        )
        .where((s) => s.items.isNotEmpty);
  }

  Future<bool?> _showLogoutConfirmDialog() {
    return showDialog<bool>(
      context: context,
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
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await AuthRepository().logout();
    if (!mounted) return;
    navigateToLogin(context);
  }

  Future<void> _onLogoutPressed() async {
    final ok = await _showLogoutConfirmDialog();
    if (ok == true && mounted) await _logout();
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
      SnackBar(content: Text('Role updated: ${UserRoles.label(user.primaryRole)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SettingsSidebar(
          search: _search,
          onSearchChanged: (v) => setState(() => _search = v),
          selectedId: _selectedId,
          onSelect: (id) => setState(() => _selectedId = id),
          sections: _filteredSections,
          onRefreshAccount: _refreshing ? null : _refreshAccount,
          onLogout: _onLogoutPressed,
          refreshing: _refreshing,
        ),
        Expanded(
          child: ColoredBox(
            color: context.pageBackground,
            child: buildSettingsPanel(_selectedId, context),
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }
}

class _SettingsSidebar extends StatelessWidget {
  const _SettingsSidebar({
    required this.search,
    required this.onSearchChanged,
    required this.selectedId,
    required this.onSelect,
    required this.sections,
    required this.onRefreshAccount,
    required this.onLogout,
    required this.refreshing,
  });

  final String search;
  final ValueChanged<String> onSearchChanged;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final Iterable<SettingsNavSection> sections;
  final VoidCallback? onRefreshAccount;
  final VoidCallback onLogout;
  final bool refreshing;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: tc.surfaceCard,
        border: Border(right: BorderSide(color: tc.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search settings...',
                hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.muted),
                prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                filled: true,
                fillColor: tc.subtleFill,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tc.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tc.borderColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              children: [
                for (final section in sections) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Text(
                      section.title,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  for (final item in section.items)
                    _NavTile(
                      item: item,
                      selected: item.id == selectedId,
                      onTap: () => onSelect(item.id),
                    ),
                ],
              ],
            ),
          ),
          Divider(height: 1, color: tc.borderColor),
          ListenableBuilder(
            listenable: SessionNotifier.instance,
            builder: (context, _) {
              final user = SessionNotifier.instance.user;
              final email = user?.email ?? '—';
              final role = UserRoles.label(user?.primaryRole);
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tc.primaryText,
                      ),
                    ),
                    Text(role, style: GoogleFonts.dmSans(fontSize: 11, color: tc.secondaryText)),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: onRefreshAccount,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: refreshing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Refresh account'),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: onLogout,
                      style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SettingsNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected
            ? (tc.isDarkMode
                ? AppColors.brandBlue.withValues(alpha: 0.25)
                : const Color(0xFFEFF6FF))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: selected ? tc.filterChipText : tc.secondaryText,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? tc.filterChipText : tc.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
