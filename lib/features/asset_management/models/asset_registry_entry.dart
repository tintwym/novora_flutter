import '../widgets/asset_ui_helpers.dart';

/// Row in the asset registry table (mock / in-memory until API exists).
class AssetRegistryEntry {
  const AssetRegistryEntry({
    required this.name,
    required this.tag,
    required this.category,
    required this.assigneeLabel,
    this.assigneeInitials,
    required this.purchaseDate,
    required this.cost,
    required this.bookValue,
    required this.status,
    required this.statusTone,
  });

  final String name;
  final String tag;
  final String category;
  final String? assigneeInitials;
  final String assigneeLabel;
  final String purchaseDate;
  final String cost;
  final String bookValue;
  final String status;
  final AssetPillTone statusTone;

  static List<AssetRegistryEntry> seed() => [
        const AssetRegistryEntry(
          name: 'MacBook Pro 14"',
          tag: 'AST-IT-0021',
          category: 'IT equipment',
          assigneeInitials: 'SL',
          assigneeLabel: 'Sarah Lim',
          purchaseDate: '12 Jan 2021',
          cost: '8,500',
          bookValue: '4,250',
          status: 'Active',
          statusTone: AssetPillTone.success,
        ),
        const AssetRegistryEntry(
          name: 'Toyota Hilux (WMB 1234)',
          tag: 'AST-VH-0008',
          category: 'Vehicle',
          assigneeInitials: 'RK',
          assigneeLabel: 'Raj Kumar',
          purchaseDate: '3 Jun 2020',
          cost: '95,000',
          bookValue: '47,500',
          status: 'Active',
          statusTone: AssetPillTone.success,
        ),
        const AssetRegistryEntry(
          name: 'Standing desk',
          tag: 'AST-FN-0142',
          category: 'Furniture',
          assigneeLabel: '—',
          purchaseDate: '8 Mar 2023',
          cost: '1,200',
          bookValue: '960',
          status: 'Unassigned',
          statusTone: AssetPillTone.neutral,
        ),
        const AssetRegistryEntry(
          name: 'HP LaserJet',
          tag: 'AST-OE-0088',
          category: 'Office equipment',
          assigneeLabel: '—',
          purchaseDate: '15 Sep 2022',
          cost: '2,800',
          bookValue: '1,680',
          status: 'Maintenance',
          statusTone: AssetPillTone.warning,
        ),
        const AssetRegistryEntry(
          name: 'iPhone 14 Pro',
          tag: 'AST-IT-0199',
          category: 'IT equipment',
          assigneeLabel: '—',
          purchaseDate: '5 May 2026',
          cost: '4,800',
          bookValue: 'Written off',
          status: 'Disposed',
          statusTone: AssetPillTone.danger,
        ),
      ];
}
