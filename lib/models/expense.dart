// models/expense.dart

class Expense {
  final String category;
  late final String name;
  late final double amount;

  Expense({
    required this.category,
    required this.name,
    required this.amount,
  });
}
