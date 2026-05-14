import 'package:flutter/material.dart';

/// Segmented control for auth tabs (login / register).
class TabSwitcher extends StatelessWidget {
  const TabSwitcher({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final selected = i == index;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(labels[i]),
              selected: selected,
              onSelected: (_) => onChanged(i),
            ),
          ),
        );
      }),
    );
  }
}
