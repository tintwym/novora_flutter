import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Search row + card-wrapped [DataTable] with horizontal scroll on narrow widths.
class HrDataTableCard extends StatelessWidget {
  const HrDataTableCard({
    super.key,
    required this.searchHint,
    required this.columns,
    required this.rows,
    this.onSearchChanged,
    this.actionLabel,
    this.onAction,
  });

  final String searchHint;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final ValueChanged<String>? onSearchChanged;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, c) {
            final table = DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.bg),
              dataRowMinHeight: 48,
              horizontalMargin: 16,
              columns: columns,
              rows: rows,
            );
            if (c.maxWidth < 720) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: c.maxWidth),
                  child: table,
                ),
              );
            }
            return SingleChildScrollView(child: table);
          },
        ),
      ],
    );
  }
}
