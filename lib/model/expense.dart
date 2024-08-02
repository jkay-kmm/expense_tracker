import 'package:isar/isar.dart';
part 'expense.g.dart';

@Collection()
class Expense {
  Id id = Isar.autoIncrement;
  final String name;
  final double amount;
  final DateTime date;
  final String username;
  final String password;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.username,
    required this.password,
  });
}
