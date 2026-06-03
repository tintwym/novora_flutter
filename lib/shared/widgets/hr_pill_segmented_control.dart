import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors.dart';

/// One segment: [value] is emitted on tap; [label] is shown.
class HrPillSegment {
  const HrPillSegment({required this.value, required this.label});
  final String value;
  final String label;
}

/// HR mock–style pill: continuous rounded border, inner vertical dividers,
/// **lavender** selected fill and a **checkmark** only on the active segment.
class HrPillSegmentedControl extends StatelessWidget {
  const HrPillSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.width = 264,
    this.height = 38,
  });

  final List<HrPillSegment> segments;
  final String selected;
  final ValueChanged<String> onChanged;
  final double width;
  final double height;

  static const Color _selectedFill = Color(0xFFE8E4F8);

  @override
  Widget build(BuildContext context) {
    assert(segments.isNotEmpty);
    final border = context.borderColor;
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: 1.25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Row(
            children: [
              for (var i = 0; i < segments.length; i++)
                Expanded(
                  child: _SegmentTile(
                    segment: segments[i],
                    selected: segments[i].value == selected,
                    showRightDivider: i < segments.length - 1,
                    dividerColor: border,
                    onTap: () => onChanged(segments[i].value),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile({
    required this.segment,
    required this.selected,
    required this.showRightDivider,
    required this.dividerColor,
    required this.onTap,
  });

  final HrPillSegment segment;
  final bool selected;
  final bool showRightDivider;
  final Color dividerColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.navy : context.secondaryText;
    return Material(
      color: selected
          ? HrPillSegmentedControl._selectedFill
          : Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.primary.withValues(alpha: 0.04),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              right: showRightDivider
                  ? BorderSide(color: dividerColor, width: 1.25)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Symmetric gutters: label stays centered; check only toggles visibility.
              SizedBox(
                width: 19,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.check,
                    size: 15,
                    color: selected ? fg : Colors.transparent,
                  ),
                ),
              ),
              Text(
                segment.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              const SizedBox(width: 19),
            ],
          ),
        ),
      ),
    );
  }
}
