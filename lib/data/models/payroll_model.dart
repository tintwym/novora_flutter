/// Payroll totals / breakdown line items (expand when wiring payroll API).
class PayrollTotalsModel {
  const PayrollTotalsModel({
    required this.totalPayroll,
    required this.netPay,
    required this.deductions,
    required this.taxes,
    required this.periodLabel,
  });

  final String totalPayroll;
  final String netPay;
  final String deductions;
  final String taxes;
  final String periodLabel;
}
