import 'package:drift/drift.dart';
import 'package:budgetly/models/database.dart';

@DataClassName("TransactionWithCategory")
class TransactionWithCategory extends Table {
  final Transaction transaction;
  final Category category;
  TransactionWithCategory(this.transaction, this.category);
}
