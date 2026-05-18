import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class SettingsLabeledField extends StatelessWidget {
  const SettingsLabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.dropdownItems,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final List<String>? dropdownItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        if (dropdownItems != null)
          _SettingsDropdown(
            value: controller.text,
            items: dropdownItems!,
            onChanged: (v) => controller.text = v,
          )
        else
          TextField(
            controller: controller,
            readOnly: readOnly,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.navy),
            decoration: _fieldDecoration(),
          ),
      ],
    );
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  const _SettingsDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(value) ? value : items.first,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.navy),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class SettingsPill extends StatelessWidget {
  const SettingsPill(this.label, {super.key, this.tone = SettingsPillTone.neutral});

  final String label;
  final SettingsPillTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      SettingsPillTone.success => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      SettingsPillTone.info => (const Color(0xFFDBEAFE), AppColors.primary),
      SettingsPillTone.warning => (const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
      SettingsPillTone.purple => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      SettingsPillTone.orange => (const Color(0xFFFFEDD5), const Color(0xFF9A3412)),
      SettingsPillTone.neutral => (AppColors.bg, AppColors.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

enum SettingsPillTone { success, info, warning, purple, orange, neutral }

class SettingsKvRow extends StatelessWidget {
  const SettingsKvRow({
    super.key,
    required this.label,
    required this.value,
    this.valueWidget,
  });

  final String label;
  final String value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.navy),
            ),
          ),
          valueWidget ??
              Text(
                value,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
        ],
      ),
    );
  }
}

class SettingsSimpleTable extends StatelessWidget {
  const SettingsSimpleTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<String> columns;
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.bg),
        dataRowMinHeight: 44,
        headingRowHeight: 40,
        columns: columns
            .map(
              (c) => DataColumn(
                label: Text(
                  c,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            )
            .toList(),
        rows: rows
            .map((cells) => DataRow(cells: cells.map(DataCell.new).toList()))
            .toList(),
      ),
    );
  }
}
