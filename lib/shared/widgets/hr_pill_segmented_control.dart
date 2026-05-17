import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

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
  /// Outer capsule + dividers — slate-600 so the pill reads clearly on white.
  static const Color _border = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    assert(segments.isNotEmpty);
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _border, width: 1.25),
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
    required this.onTap,
  });

  final HrPillSegment segment;
  final bool selected;
  final bool showRightDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.navy : const Color(0xFF475569);
    return Material(
      color: selected ? HrPillSegmentedControl._selectedFill : Colors.white,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.primary.withValues(alpha: 0.04),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              right: showRightDivider
                  ? const BorderSide(color: HrPillSegmentedControl._border, width: 1.25)
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
