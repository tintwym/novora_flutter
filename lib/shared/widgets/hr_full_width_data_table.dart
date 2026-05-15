import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

/// [DataTable] that fills its parent width so columns use the card (no side gap / clip).
class HrFullWidthDataTable extends StatelessWidget {
  const HrFullWidthDataTable({
    super.key,
    this.columnSpecs,
    this.columns,
    required this.rows,
    this.dataRowMinHeight = 48,
    this.dataRowMaxHeight = 64,
    this.columnSpacing = 8,
    this.horizontalMargin = 12,
    this.headingRowColor,
  });

  /// Provide [columnSpecs] or pre-built [columns] (e.g. checkbox column).
  final List<(String label, double flex)>? columnSpecs;
  final List<DataColumn>? columns;
  final List<DataRow> rows;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double columnSpacing;
  final double horizontalMargin;
  final Color? headingRowColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final raw = constraints.maxWidth;
          final tableWidth = raw.isFinite && raw > 0
              ? raw
              : MediaQuery.sizeOf(context).width;
        final specs = columnSpecs;
        final resolvedColumns = columns ??
            (specs == null
                ? const <DataColumn>[]
                : buildColumns(
                    tableWidth: tableWidth,
                    specs: specs,
                    columnSpacing: columnSpacing,
                    horizontalMargin: horizontalMargin,
                  ));
        return DataTable(
          headingRowColor: WidgetStateProperty.all(headingRowColor ?? AppColors.bg),
          dataRowMinHeight: dataRowMinHeight,
          dataRowMaxHeight: dataRowMaxHeight,
          columnSpacing: columnSpacing,
          horizontalMargin: horizontalMargin,
          columns: resolvedColumns,
          rows: rows,
        );
        },
      ),
    );
  }

  static List<DataColumn> buildColumns({
    required double tableWidth,
    required List<(String label, double flex)> specs,
    required double columnSpacing,
    required double horizontalMargin,
  }) {
    final hMargin = horizontalMargin * 2;
    final usable = tableWidth - hMargin - columnSpacing * (specs.length - 1);
    final totalFlex = specs.fold<double>(0, (s, e) => s + e.$2);
    final headerStyle = GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
    return specs
        .map(
          (s) => DataColumn(
            label: SizedBox(
              width: usable * (s.$2 / totalFlex),
              child: Text(
                s.$1,
                style: headerStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
        .toList();
  }
}
