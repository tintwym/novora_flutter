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
  });

  final String title;
  final String? subtitle;
  final bool showSearch;
  final String? trailingDateLabel;

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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: tc.primaryText,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
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
          const SizedBox(width: 8),
          _iconButton(context, Icons.settings_outlined),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tc.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (trailingDateLabel != null)
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
