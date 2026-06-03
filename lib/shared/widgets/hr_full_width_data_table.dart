import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors.dart';

/// Full-width table that stretches to the parent (card) width using flex columns.
class HrFullWidthDataTable extends StatelessWidget {
  const HrFullWidthDataTable({
    super.key,
    this.columnSpecs,
    this.columns,
    this.columnFlexes,
    this.headerCells,
    required this.rows,
    this.dataRowMinHeight = 48,
    this.dataRowMaxHeight = 64,
    this.cellHorizontalPadding = 12,
    this.headingRowColor,
    this.intrinsicColumnIndexes,
    this.edgeToEdge = false,
  });

  /// Column labels and flex weights (e.g. `('Name', 2.0)`).
  final List<(String label, double flex)>? columnSpecs;

  /// Pre-built headers (e.g. checkbox). Use with [columnFlexes] when widths differ.
  final List<DataColumn>? columns;

  /// Flex per column when using [columns]. Defaults to equal flex.
  final List<double>? columnFlexes;

  /// Optional header widgets; `null` entries use the label from [columnSpecs].
  final List<Widget?>? headerCells;

  final List<DataRow> rows;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double cellHorizontalPadding;
  final Color? headingRowColor;

  /// Columns sized to content; remaining width goes to flex columns.
  final Set<int>? intrinsicColumnIndexes;

  /// No outer horizontal inset (use inside a card with zero horizontal padding).
  final bool edgeToEdge;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final raw = constraints.maxWidth;
        final tableWidth = raw.isFinite && raw > 0
            ? raw
            : MediaQuery.sizeOf(context).width;

        final flexes = _resolveFlexes();
        final headers = _resolveHeaders(flexes.length);
        if (flexes.isEmpty) return const SizedBox.shrink();

        final intrinsic = intrinsicColumnIndexes ?? const {};
        final colWidths = <int, TableColumnWidth>{
          for (var i = 0; i < flexes.length; i++)
            i: intrinsic.contains(i)
                ? const IntrinsicColumnWidth()
                : FlexColumnWidth(flexes[i]),
        };

        final hPad = edgeToEdge ? 0.0 : cellHorizontalPadding;

        return SizedBox(
          width: tableWidth,
          child: Table(
            columnWidths: colWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(
              horizontalInside: BorderSide(color: context.borderColor),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: headingRowColor ?? context.tableHeaderBg,
                ),
                children: headers
                    .map(
                      (h) => _tableCell(
                        h,
                        minHeight: dataRowMinHeight,
                        isHeader: true,
                        horizontalPadding: hPad,
                      ),
                    )
                    .toList(),
              ),
              ...rows.map(
                (row) => TableRow(
                  children: _cellsForRow(row, flexes.length, hPad),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _cellsForRow(DataRow row, int columnCount, double horizontalPadding) {
    final widgets = row.cells.map((c) => c.child).toList();
    if (widgets.length < columnCount) {
      widgets.addAll(
        List.filled(columnCount - widgets.length, const SizedBox.shrink()),
      );
    } else if (widgets.length > columnCount) {
      widgets.removeRange(columnCount, widgets.length);
    }
    return widgets
        .map(
          (w) => _tableCell(
            w,
            minHeight: dataRowMinHeight,
            maxHeight: dataRowMaxHeight,
            horizontalPadding: horizontalPadding,
          ),
        )
        .toList();
  }

  List<double> _resolveFlexes() {
    if (columnSpecs != null) {
      return columnSpecs!.map((s) => s.$2).toList();
    }
    if (columns != null) {
      final n = columns!.length;
      if (columnFlexes != null && columnFlexes!.length == n) {
        return columnFlexes!;
      }
      return List.filled(n, 1.0);
    }
    return const [];
  }

  List<Widget> _resolveHeaders(int count) {
    final style = GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );

    if (headerCells != null) {
      assert(
        columnSpecs != null && headerCells!.length == count,
        'headerCells length must match columnSpecs',
      );
      return List.generate(count, (i) {
        final custom = headerCells![i];
        if (custom != null) return custom;
        final label = columnSpecs![i].$1;
        if (label.isEmpty) return const SizedBox.shrink();
        return Text(label, style: style, maxLines: 2, overflow: TextOverflow.ellipsis);
      });
    }

    if (columnSpecs != null) {
      return columnSpecs!
          .map(
            (s) => s.$1.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    s.$1,
                    style: style,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          )
          .toList();
    }

    return columns!.map((c) => c.label).toList();
  }

  Widget _tableCell(
    Widget child, {
    required double minHeight,
    double? maxHeight,
    bool isHeader = false,
    required double horizontalPadding,
  }) {
    final edgePad = edgeToEdge ? 16.0 : horizontalPadding;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        edgePad,
        isHeader ? 12 : 10,
        edgePad,
        isHeader ? 12 : 10,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Legacy helper — prefer [columnSpecs] + [headerCells] on [HrFullWidthDataTable].
  @Deprecated('Use columnSpecs and headerCells on HrFullWidthDataTable instead')
  static List<DataColumn> buildColumns({
    required double tableWidth,
    required List<(String label, double flex)> specs,
    double columnSpacing = 8,
    double horizontalMargin = 12,
  }) {
    final headerStyle = GoogleFonts.dmSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
    return specs
        .map(
          (s) => DataColumn(
            label: Text(
              s.$1,
              style: headerStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }
}
