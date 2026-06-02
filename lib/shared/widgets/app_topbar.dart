import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/theme_colors.dart';
import '../../data/models/user_model.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showSearch = true,
    this.trailingDateLabel,
    this.onOpenSettings,
    this.onLogout,
  });

  final String title;
  final String? subtitle;
  final bool showSearch;
  final String? trailingDateLabel;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onLogout;

  UserModel? _readUser() {
    final raw = LocalStorage.instance.userJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromAuthJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  String _usernameLabel(UserModel? user) {
    if (user == null) return 'Signed in';
    final name = user.displayName.trim();
    if (name.isNotEmpty) return name;
    final email = user.email.trim();
    if (email.isNotEmpty) return email;
    return 'Signed in';
  }

  String _initials(UserModel? user) {
    final name = _usernameLabel(user);
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tc = context;
    final user = _readUser();
    final username = _usernameLabel(user);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: tc.surfaceCard,
        border: Border(bottom: BorderSide(color: tc.borderColor)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: tc.primaryText,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: tc.secondaryText,
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (showSearch)
            SizedBox(
              width: 280,
              height: 40,
              child: TextField(
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: tc.primaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search employees, modules...',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.muted,
                    size: 20,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _iconButton(context, Icons.notifications_outlined),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '5',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          TopBarUserMenu(
            username: username,
            email: user?.email,
            initials: _initials(user),
            onOpenSettings: onOpenSettings,
            onLogout: onLogout,
          ),
          if (trailingDateLabel != null) ...[
            const SizedBox(width: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.muted,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  trailingDateLabel!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: tc.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) {
    final tc = context;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: tc.subtleFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.borderColor, width: 1.5),
      ),
      child: Icon(icon, color: tc.primaryText, size: 20),
    );
  }
}

/// Account menu: Settings + Log out (replaces standalone settings icon).
class TopBarUserMenu extends StatelessWidget {
  const TopBarUserMenu({
    super.key,
    required this.username,
    required this.initials,
    this.email,
    this.onOpenSettings,
    this.onLogout,
  });

  final String username;
  final String initials;
  final String? email;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return PopupMenuButton<String>(
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'settings':
            onOpenSettings?.call();
          case 'logout':
            onLogout?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: tc.primaryText,
                ),
              ),
              if (email != null && email!.isNotEmpty)
                Text(
                  email!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: tc.secondaryText,
                  ),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20, color: tc.primaryText),
              const SizedBox(width: 10),
              Text(
                'Settings',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tc.primaryText,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 20, color: AppColors.danger),
              const SizedBox(width: 10),
              Text(
                'Log out',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ],
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: tc.subtleFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tc.borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.brandBlue.withValues(alpha: 0.12),
                child: Text(
                  initials,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlueDeep,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tc.primaryText,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: tc.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
