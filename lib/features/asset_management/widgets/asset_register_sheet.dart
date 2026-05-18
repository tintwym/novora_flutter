import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../models/asset_registry_entry.dart';
import 'asset_ui_helpers.dart';

/// Bottom sheet to register a new asset in the registry (mock — in-memory).
class AssetRegisterSheet extends StatefulWidget {
  const AssetRegisterSheet({super.key, required this.existingTags});

  final List<String> existingTags;

  @override
  State<AssetRegisterSheet> createState() => _AssetRegisterSheetState();
}

class _AssetRegisterSheetState extends State<AssetRegisterSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  String _category = 'IT equipment';
  String _status = 'Unassigned';

  static const _categories = [
    'IT equipment',
    'Furniture',
    'Vehicle',
    'Office equipment',
    'Property',
  ];

  static const _statuses = ['Active', 'Unassigned', 'Maintenance'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tagCtrl.dispose();
    _brandCtrl.dispose();
    _serialCtrl.dispose();
    _costCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  String _suggestTag() {
    final prefix = switch (_category) {
      'IT equipment' => 'AST-IT',
      'Furniture' => 'AST-FN',
      'Vehicle' => 'AST-VH',
      'Office equipment' => 'AST-OE',
      'Property' => 'AST-PR',
      _ => 'AST-XX',
    };
    final n = widget.existingTags.where((t) => t.startsWith(prefix)).length + 1;
    return '$prefix-${n.toString().padLeft(4, '0')}';
  }

  AssetPillTone _statusTone(String status) => switch (status) {
        'Active' => AssetPillTone.success,
        'Maintenance' => AssetPillTone.warning,
        _ => AssetPillTone.neutral,
      };

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final tag = _tagCtrl.text.trim().toUpperCase();
    if (widget.existingTags.any((t) => t.toUpperCase() == tag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset tag already exists.')),
      );
      return;
    }
    final cost = _costCtrl.text.trim().isEmpty ? '0' : _costCtrl.text.trim();
    Navigator.pop(
      context,
      AssetRegistryEntry(
        name: _nameCtrl.text.trim(),
        tag: tag,
        category: _category,
        assigneeLabel: _status == 'Active' ? 'Pending assignment' : '—',
        purchaseDate: 'Today',
        cost: cost,
        bookValue: cost,
        status: _status,
        statusTone: _statusTone(_status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Register asset',
                      style: GoogleFonts.sora(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: tc.primaryText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Add a new asset to the registry. Required fields are marked with *.',
                style: GoogleFonts.dmSans(fontSize: 13, color: tc.secondaryText),
              ),
              const SizedBox(height: 20),
              _field(
                context,
                label: 'Asset name *',
                controller: _nameCtrl,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter asset name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _field(
                      context,
                      label: 'Asset tag *',
                      controller: _tagCtrl,
                      hint: _suggestTag(),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Enter asset tag' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: TextButton(
                      onPressed: () => setState(() => _tagCtrl.text = _suggestTag()),
                      child: const Text('Suggest'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _dropdown(
                context,
                label: 'Category *',
                value: _category,
                items: _categories,
                onChanged: (v) => setState(() {
                  _category = v!;
                  if (_tagCtrl.text.isEmpty) _tagCtrl.text = _suggestTag();
                }),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _field(context, label: 'Brand', controller: _brandCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(context, label: 'Serial no.', controller: _serialCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      context,
                      label: 'Acquisition cost (MYR)',
                      controller: _costCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dropdown(
                      context,
                      label: 'Status',
                      value: _status,
                      items: _statuses,
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _field(context, label: 'Location', controller: _locationCtrl, hint: 'e.g. KL HQ — Store room'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save to registry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    final tc = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: tc.subtleFill,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: tc.borderColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final tc = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: tc.subtleFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
